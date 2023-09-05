/// courtsey: https://www.donnywals.com/recursively-execute-a-paginated-network-call-with-combine/
///
import Combine
import Foundation

// expectation:
/*
networking.loadPages()
  .sink(receiveCompletion: { _ in
    // handle errors
  }, receiveValue: { items in
    print(items)
  })
  .store(in: &cancellables)
*/

// loadPages() will return a publisher that emits data for all pages at once. I don't want to receive all intermediate pages in my sink. The publisher completes immediately after delivering my complete data set.

//The tricky bit here is that this means that in loadPages() we'll need to somehow create a publisher that collects the responses from several network calls, bundles them into one big result, and outputs them to the created publisher.



// model response struct

struct Response {
  var hasMorePages = true
  var items = [Item(), Item()]
}

struct Item {}

// My loader should keep making more requests until it receives a Response that has its hasMorePages set to false. At that point, the chain is considered complete and the publisher created in loadPages() should emit all fetched values and complete.

// model class

class RecursiveLoader {
    var requestsMade = 0
    var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    private func loadPage() -> AnyPublisher<Response, Never> {
        // individual network call
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1, execute: DispatchWorkItem(block: {
                self.requestsMade += 1
                if self.requestsMade < 5 {
                    return promise(.success(Response()))
                }
                else {
                    return promise(.success(Response(hasMorePages: false)))
                }
            }))
        }.eraseToAnyPublisher()
    }
}

// -------------------------------------------------------------------------------------
// Attempt one: using reduce operator
// -------------------------------------------------------------------------------------


// When you apply reduce to a publisher in Combine you can accumulate all emitted values into one new value that's emitted when the upstream publisher completes.
// To load all pages I would create an instance of RecursiveLoader, subscribe to a publisher that I'd define as a property on RecursiveLoader and tell it to begin loading


// updating RecursiveLoader
class RecursiveLoader1 {
  var requestsMade = 0

  private let loadedPagePublisher = PassthroughSubject<Response, Never>()
  let finishedPublisher: AnyPublisher<[Item], Never>

  var cancellables = Set<AnyCancellable>()

  init() {
    self.finishedPublisher = loadedPagePublisher
      .reduce([Item](), { allItems, response in
        return response.items + allItems
      })
      .eraseToAnyPublisher()
      
//      loadedPagePublisher.reduce([Item]()) { allItems, response in
//          return response.items + allItems
//      }.eraseToAnyPublisher()
  }
    
    private func loadPage() -> AnyPublisher<Response, Never> {
        // individual network call
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1, execute: DispatchWorkItem(block: {
                self.requestsMade += 1
                if self.requestsMade < 5 {
                    return promise(.success(Response()))
                }
                else {
                    return promise(.success(Response(hasMorePages: false)))
                }
            }))
        }.eraseToAnyPublisher()
    }

    func initiateLoadSequence() {
      loadPage()
        .sink(receiveValue: { response in
          self.loadedPagePublisher.send(response)

          if response.hasMorePages == false {
            self.loadedPagePublisher.send(completion: .finished)
          } else {
            self.initiateLoadSequence()
          }
        })
        .store(in: &cancellables)
    }
    // In initiateLoadSequence() I call loadPage() and subscribe to the publisher returned by loadPage(). When I receive a response I forward that response to loadedPagePublisher and if we don't have any more pages to load, I complete the loadedPagePublisher so the finishedPublisher emits its array of Item objects. If we do have more pages to load, I call self.initiateLoadSequence() again to load the next page.
}


let loader1 = RecursiveLoader1()
loader1.finishedPublisher.sink { items in
    print("items : \(items.count)")
}.store(in: &cancellables)
loader1.initialLoadSequence()



// private loadedPagePublisher is where I decided I would publish pages as they came in from the network.
// The finishedPublisher takes the loadedPagePublisher and applies the reduce operator. That way, once I complete the loadedPagePublisher, the finsihedPublisher will emit an array of [Item]

// An instance of RecursiveLoader can only load all pages once, and users of this object will need to subscriber to finishedPublisher before calling initiateLoadSequence to prevent dropping events since the loadedPagePublisher will not emit any values if it doesn't have any subscribers. For loadedPagePublisher to have subscribers, users of RecursiveLoader must subscribe to finishedPublisher since that publisher is built upon loadedPagePublisher.


// -------------------------------------------------------------------------------------
// Attempt two
// -------------------------------------------------------------------------------------

// issue with 1st attempt : finishedPublisher and loadedPagePublisher made RecursiveLoader into a non-reusable object that can only load all pages once.

// function loadPages() that would create a publisher in its own scope and then pass that publisher to a function that would load an individual page, and then send its result to loadPagePublisher

// updating RecursiveLoader

class RecursiveLoader2 {
    var requestsMade = 0
    var cancellables = Set<AnyCancellable>()
    
    init() { }
    
    private func loadPage() -> AnyPublisher<Response, Never> {
        // individual network call
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1, execute: DispatchWorkItem(block: {
                self.requestsMade += 1
                if self.requestsMade < 5 {
                    return promise(.success(Response()))
                }
                else {
                    return promise(.success(Response(hasMorePages: false)))
                }
            }))
        }.eraseToAnyPublisher()
    }
    
    private func performLoadPage(using publisher: PassthroughSubject<Response, Never>) {
        loadPages().sink { [weak self] response in
            publisher.send(response)
            
            if response.hasMorePages {
                self?.performLoadPage(using: publisher)
            }
            else {
                self?.requestsMade = 0
                publisher.send(completion: .finished)
            }
        }.store(in: &cancellables)
    }
    
    func loadPages() -> AnyPublisher<[Item], Never> {
        let intermediatePublisher = PassthroughSubject<Response, Never>()
        
        return intermediatePublisher.reduce([Item]()) { allItems, response in
            return response.items + allItems
        }.handleEvents(receiveSubscription: { [weak self] _ in
            self?.performLoadPage(using: intermediatePublisher)
        })
        .eraseToAnyPublisher()
    }
}

// Now, there is no longer any publishers defined as properties of RecursiveLoader. Instead, loadPages() now returns an AnyPublisher<[Item], Never> that I can subscribe to directly which is much cleaner. Inside loadPages() I create a publisher that will be used to push new responses on by the performPageLoad(using:) method. The loadPages() method returns the intermediate publisher but applies a reduce on it to collect all intermediate responses and create an array of items.

// I also use the handleEvents() function to hook into receiveSubscription. This allows me to kick off the page loading as soon as the publisher returned by loadPages is subscribed to. By doing this users of loadPage() don't have to kick off any loading manually and they can't forget to subscribe before starting the loading process like they could in my initial attempt.

// The performPageLoad(using:) takes a PassthroughSubject<Response, Never> as its argument. Inside of this method, I call loadPage() and subscribe to its result. I then send the received result using the received subject and complete it if there are no more pages to load. If there are more pages to load, I call performPageLoad(using:) again, and pass the same subject along to that method so that next call will also publish its result on the same passthrough subject so I can reduce it into my collection of items.

// Usage:
let networking = RecursiveLoader2()
networking.loadPages()
  .sink(receiveCompletion: { _ in
    // handle errors
  }, receiveValue: { items in
    print(items)
  })
  .store(in: &cancellables)


// issues :
// performPageLoad(using:) must emit its values asynchrononously. For an implementation like this were you rely on the network that's not a problem. But if you'd modify my loadPage method and remove the delay that I have added before completing my Future, you'll find that a number of items are dropped because the PassthroughSubject didn't forward them into the reduce since the publisher created by loadPage() wasn't set up just yet. The reason for this is that receiveSubscription is called just before the subscription is completely set up and established.

// Additionally, I subscribe to the publisher created by loadPage() in performPageLoad(using:) which is also not ideal, but doesn't directly harm the implementation.


// -------------------------------------------------------------------------------------
// Attempt three
// -------------------------------------------------------------------------------------

// updating Response
struct Response1 {
  var hasMorePages = true
  var items = [Item(), Item()]
  var nextPageIndex = 0
}

// updating RecursiveLoader
class RecursiveLoader3 {
    init() { }
    
    private func loadPage(withIndex index: Int) -> AnyPublisher<Response1, Never> {
        // this would be the individual network call
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                let nextIndex = index + 1
                if nextIndex < 5 {
                    return promise(.success(Response1(nextPageIndex: nextIndex)))
                } else {
                    return promise(.success(Response1(hasMorePages: false)))
                }
            }
        }.eraseToAnyPublisher()
    }
    // The loader no longer tracks the number of requests it has made. The loadPage() method is now loadPage(withIndex:). This index represents the page that should be loaded
    
    func loadPages() -> AnyPublisher<[Item], Never> {
      let pageIndexPublisher = CurrentValueSubject<Int, Never>(0)

      return pageIndexPublisher
        .flatMap({ index in
          return self.loadPage(withIndex: index)
        })
        .handleEvents(receiveOutput: { (response: Response1) in
          if response.hasMorePages {
            pageIndexPublisher.send(response.nextPageIndex)
          } else {
            pageIndexPublisher.send(completion: .finished)
          }
        })
        .reduce([Item](), { allItems, response in
          return response.items + allItems
        })
        .eraseToAnyPublisher()
    }
    
    // Inside loadPages() a CurrentValueSubject is used to drive the loading of pages. Since we want to start loading pages when somebody subscribes to the publisher created by loadPages(), a CurrentValueSubject makes sense because it emits its current (initial) value once it receives a subscriber. The publisher returned by loadPages() applies a flatMap to pageIndexPublisher. Inside of the flatMap, the page index emitted by pageIndexPublisher is used to create a new loadPage publisher that will load the page at a certain index. After the flatMap, handleEvents(receiveOutput:) is used to determine whether the nextPageIndex should be sent through the pageIndexPublisher or if the pageIndexPublisher should be completed. When the nextPageIndex is emitted by the pageIndexPublisher, this triggers another call to loadPage(withIndex:) in the flatMap.
    
   // Since we still use a reduce after handleEvents(receiveOutput:), all results from the flatMap are still collected and an array of Item objects is still emitted when pageIndexPublisher completed.
}


// Working:
//When the publisher that's returned by loadPages() receives a subscriber, pageIndexPublisher immediately emits its initial value: 0. This value is transformed into a publisher using flatMap by returning a publisher created by loadPage(withIndex:). The loadPage(withIndex:) fakes a network requests and produces a Response1 value.

//This Response1 is passed to handleEvents(receiveOutput:), where it's inspected to see if there are more pages to be loaded. If more pages need to be loaded, pageIndexPublisher emits the index for the next page which will be forwarded into flatMap so it can be converted into a new network call. If there are no further pages available, the pageIndexPublisher sends a completion event.

//After the Response1 is inspected by handleEvents(receiveOutput:), it is forwarded to the reduce where the Response1 object's item property is used to build an array of Item objects. The reduce will keep collecting items until the pageIndexPublisher sends its completion event.
