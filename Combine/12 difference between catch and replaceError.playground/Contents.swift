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





// When to use replaceError
// you cannot throw errors in catch. You must always return a valid publisher. If you only want to create a new publisher for a specific error, and otherwise forward the thrown error, you can use tryCatch which allows you to throw errors.

//With replaceError you can provide a default value that's used to replace any thrown error from upstream publishers. Note that this operator changes your Failure type to Never because with this operator in place, it will become impossible for your pipeline to fail. This is different from catch because the publisher you create in the catch operator might still fail.

enum MyError: Error {
  case failed
}

var replaceErrorCancellables = Set<AnyCancellable>()
var subject = PassthroughSubject<Int, Error>()

subject
  .replaceError(with: 42)
  .sink(receiveCompletion: { completion in
    print(completion)
  }, receiveValue: { int in
    print(int)
  })
  .store(in: &replaceErrorCancellables)

subject.send(1)
subject.send(2)
subject.send(completion: .failure(MyError.failed))

// Note that in catch, the publisher that emitted the error that triggered the catch completes when it emits an error. The publisher you return from catch does not have to complete immediately and it replaces the failed publisher completely. So your sink could receive several values after the source publisher failed because the replacement publisher is still active.


