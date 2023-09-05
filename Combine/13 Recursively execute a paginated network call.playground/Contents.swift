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
/*
class RecursiveLoader {
    var requestsMade = 0
    var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    private func loadPages() -> AnyPublisher<Response, Never> {
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
    
    func finishedPublisher() -> AnyPublisher<Response, Never> {
        Future {promise in
            
        }.eraseToAnyPublisher()
    }
    
    func initialLoadSequence() {
        
    }
}*/

// -------------------------------------------------------------------------------------
// Attempt one: using reduce operator
// -------------------------------------------------------------------------------------


// When you apply reduce to a publisher in Combine you can accumulate all emitted values into one new value that's emitted when the upstream publisher completes.
// To load all pages I would create an instance of RecursiveLoader, subscribe to a publisher that I'd define as a property on RecursiveLoader and tell it to begin loading

/*
// updating RecursiveLoader
class RecursiveLoader {
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
    
    private func loadPages() -> AnyPublisher<Response, Never> {
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
      loadPages()
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


let loader = RecursiveLoader()
loader.finishedPublisher.sink { items in
    print("items : \(items.count)")
}.store(in: &cancellables)
loader.initialLoadSequence()

*/

// private loadedPagePublisher is where I decided I would publish pages as they came in from the network.
// The finishedPublisher takes the loadedPagePublisher and applies the reduce operator. That way, once I complete the loadedPagePublisher, the finsihedPublisher will emit an array of [Item]

// An instance of RecursiveLoader can only load all pages once, and users of this object will need to subscriber to finishedPublisher before calling initiateLoadSequence to prevent dropping events since the loadedPagePublisher will not emit any values if it doesn't have any subscribers. For loadedPagePublisher to have subscribers, users of RecursiveLoader must subscribe to finishedPublisher since that publisher is built upon loadedPagePublisher.


// -------------------------------------------------------------------------------------
// Attempt two
// -------------------------------------------------------------------------------------

// issue with 1st attempt : finishedPublisher and loadedPagePublisher made RecursiveLoader into a non-reusable object that can only load all pages once.

// function loadPages() that would create a publisher in its own scope and then pass that publisher to a function that would load an individual page, and then send its result to loadPagePublisher

// updating RecursiveLoader
class RecursiveLoader {
    var requestsMade = 0
    var cancellables = Set<AnyCancellable>()
    
    init() { }
    
    private func loadPages() -> AnyPublisher<Response, Never> {
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
let networking = RecursiveLoader()
networking.loadPages()
  .sink(receiveCompletion: { _ in
    // handle errors
  }, receiveValue: { items in
    print(items)
  })
  .store(in: &cancellables)
