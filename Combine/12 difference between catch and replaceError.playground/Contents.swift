///courtsey:
///https://www.donnywals.com/whats-the-difference-between-catch-and-replaceerror-in-combine/
///
import Combine
import Foundation

// Most commonly you will either use catch or replaceError if you want to implement a mechanism that allows you to recover from an error.

//When to use catch
//The catch operator is used if you want to inspect the error that was emitted by an upstream publisher, and replace the upstream publisher with a new publisher.

let practicalCombine = URL(string: "https://practicalcombine.com")!
let donnywals = URL(string: "https://donnywals.com")!

var cancellables = Set<AnyCancellable>()

URLSession.shared.dataTaskPublisher(for: practicalCombine)
  .catch({ urlError in
    return URLSession.shared.dataTaskPublisher(for: donnywals)
  })
  .sink(receiveCompletion: { completion in
    // handle completion
  }, receiveValue: { value in
    // handle response
  })
  .store(in: &cancellables)

// In this example I replace any errors emitted by my initial data task publisher with a new data task publisher. Depending on your needs and the emitted error, you can return any kind of publisher you want from your catch. The only thing you need to keep in mind is that the publisher you create must have the same Output and Failure as the publisher that the catch is applied to


