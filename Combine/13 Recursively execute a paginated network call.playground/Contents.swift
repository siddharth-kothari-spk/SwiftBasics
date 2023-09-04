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


// Attempt one: using reduce operator
// When you apply reduce to a publisher in Combine you can accumulate all emitted values into one new value that's emitted when the upstream publisher completes.
// To load all pages I would create an instance of RecursiveLoader, subscribe to a publisher that I'd define as a property on RecursiveLoader and tell it to begin loading

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

  func initiateLoadSequence() {
    // do something
  }
}


let loader = RecursiveLoader()
loader.finishedPublisher.sink { items in
    print("items : \(items.count)")
}.store(in: &cancellables)
loader.initialLoadSequence()

// private loadedPagePublisher is where I decided I would publish pages as they came in from the network.
// The finishedPublisher takes the loadedPagePublisher and applies the reduce operator. That way, once I complete the loadedPagePublisher, the finsihedPublisher will emit an array of [Item]

