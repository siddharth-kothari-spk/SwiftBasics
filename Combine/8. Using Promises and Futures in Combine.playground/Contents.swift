/// courtsey: https://www.donnywals.com/using-promises-and-futures-in-combine/
///
import Combine

// In Combine, a Future is implemented as a Publisher that only emits a single value, or an error.
func createFuture() -> Future<Int, Never> {
    return Future {promise in
        print("Closure executed")
        promise(.success(42))
    }
}

// The result of a Future is retrieved in the exact same way that you would get values from a publisher. You can subscribe to it using sink, assign or a custom subscriber

createFuture().sink { value in
    print("value: \(value)")
}

/*
createFuture().sink(receiveValue: { value in
  print(value)
})
*/
// In the body of createFuture, an instance of a Future is created. The initializer for Future takes a closure. In this closure, we can perform asynchronous work, or in other words, the work we're wrapping in the Future. The closure passed to Future's initializer takes a single argument. This argument is a Promise. A Promise in Combine is a typealias for a closure that takes a Result as its single argument. When we're done performing our asynchronous work, we must invoke the promise with the result of the work done.


// The way a Future generates its output is quite different from other publishers that Combine offers out of the box. Typically, a publisher in Combine will not begin producing values until a subscriber is attached to it. A Future immediately begins executing as soon it's created.

let future = createFuture()

// In addition to immediately executing the closure supplied to the Future's initializer, a Future will only run this closure once. In other words, subscribing to the same Future multiple times will yield the same result every time you subscribe


// A Future will begin executing immediately when you create it.
//A Future will only run its supplied closure once.
//Subscribing to the same Future multiple times will yield in the same result being returned.
//A Future in Combine serves a similar purpose as RxSwift's Single but they behave differently.


// Deferring Future
//If we want your Future to  defer its execution until it receives a subscriber, and having the work execute every time you subscribe you can wrap your Future in a Deferred publisher.

func createDeferredFuture() -> AnyPublisher<Int, Never> {
  return Deferred {
    Future { promise in
      print("Closure executed")
      promise(.success(42))
    }
  }.eraseToAnyPublisher()
}

let deferredFuture = createDeferredFuture()  // nothing happens yet

let sub1 = deferredFuture.sink(receiveValue: { value in
  print("sub1: \(value)")
}) // the Future executes because it has a subscriber

let sub2 = deferredFuture.sink(receiveValue: { value in
  print("sub2: \(value)")
}) // the Future executes again because it received another subscriber

// The Deferred publisher's initializer takes a closure. We're expected to return a publisher from this closure. In this case we return a Future. The Deferred publisher runs its closure every time it receives a subscriber. This means that a new Future is created every time we subscribe to the Deferred publisher. So the Future still runs only once and executes immediately when it's created, but we defer the creation of the Future to a later time.


// Wrapping an existing asynchronous operation in a Future
// sample
extension UNUserNotificationCenter {
  func getNotificationSettings() -> Future<UNNotificationSettings, Never> {
    return Future { promise in
      self.getNotificationSettings { settings in
        promise(.success(settings))
      }
    }
  }
}

// The extension includes a single function that returns a Future<UNNotificationSettings, Never>. In the function body, a Future is created and returned. The interesting bit is in the closure that is passed to the Future initializer. In that closure, the regular, completion handler based version of getNotificationSettings is called on the current UNUserNotificationCenter instance. Inside of the completion handler, the promise closure is called with a successful result that includes the current notification settings.

extension UNUserNotificationCenter {
  func requestAuthorization(options: UNAuthorizationOptions) -> Future<Bool, Error> {
    return Future { promise in
      self.requestAuthorization(options: options) { result, error in
        if let error = error {
          promise(.failure(error))
        } else {
          promise(.success(result))
        }
      }
    }
  }
}

//This second extension on UNUserNotificationCenter adds a new flavor of requestAuthorization(options:) that returns a Future that tells us whether we successfully received notification permissions from a user.


// code prior to extensions
UNUserNotificationCenter.current().getNotificationSettings { settings in
  switch settings.authorizationStatus {
  case .denied:
    DispatchQueue.main.async {
      // update UI to point user to settings
    }
  case .notDetermined:
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
      if result == true && error == nil {
        // We have notification permissions
      } else {
        DispatchQueue.main.async {
          // Something went wrong / we don't have permission.
          // update UI to point user to settings
        }
      }
    }
  default:
    // assume permissions are fine and proceed
    break
  }
}
// we check the current notification permissions, and we update the UI based on the result.


// code after future
UNUserNotificationCenter.current().getNotificationSettings()
  .flatMap({ settings -> AnyPublisher<Bool, Never> in
    switch settings.authorizationStatus {
    case .denied:
      return Just(false)
        .eraseToAnyPublisher()
    case .notDetermined:
      return UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        .replaceError(with: false)
        .eraseToAnyPublisher()
    default:
      return Just(true)
        .eraseToAnyPublisher()
    }
  })
  .sink(receiveValue: { hasPermissions in
    if hasPermissions == false {
      DispatchQueue.main.async {
        // point user to settings
      }
    }
  })

/*
 Get the current notification settings
 Transform the result to a Bool
 Update the UI based on whether we have permissions
 */

