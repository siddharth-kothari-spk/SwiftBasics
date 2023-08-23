/// courtsey: https://www.donnywals.com/an-introduction-to-combine/
///
import Combine
import UIKit

// 1. Subscribing to a simple publisher
[1,2,3]
    .publisher // i)
    .sink(receiveCompletion: { // ii)
        completion in
        switch completion {
        case .failure(let error):
            print("error: \(error)")
        case .finished:
            print("completion received")
        }
    }, receiveValue: { value in // iii)
        print("received value: \(value)")
    })

/// i) The Combine framework adds a publisher property to Array. We can use this property to turn an array of values into a publisher that will publish all values in the array to the subscribers of the publisher.
///  The type of the created publisher is Publishers.Sequence<[Int], Never>
/// all the built-in publishers in the Combine framework are grouped under the Publishers enum. Each of the publishers that exist in this namespace conforms to the Publisher protocol
/// Every publisher in Combine has an Output and a Failure type. The Output is the type of value that a publisher will push to its subscribers. In the case of our Sequence, the Output will be Int. The Failure type is Never because the publisher cannot finish with an error.
///
///
///  ii) You can subscribe to a publisher using the sink(receiveCompletion:receiveValue:) method. This method creates a subscriber that is subscribed to the publisher that the method was called on.
///
///
///  iii) The receiveValue closure is called whenever a new value is published by the publisher. This closure receives the latest value of the publisher as its single argument



// 2. Keeping track of subscriptions
/// If you examine the return type of sink, you will find that it's AnyCancellable. An AnyCancellable object is a type-erased wrapper around a Cancellable subscription that you can hold on to in your view controller.

var subscription: AnyCancellable?

func subscribe() {
  let notification = UIApplication.keyboardDidShowNotification
  let publisher = NotificationCenter.default.publisher(for: notification)
  subscription = publisher.sink(receiveCompletion: { _ in // i)
    print("Completion")
  }, receiveValue: { notification in
    print("Received notification: \(notification)")
  })
}

subscribe()
NotificationCenter.default.post(Notification(name: UIApplication.keyboardDidShowNotification))

/// i) If you place this code in a Playground, you'll find that the print statement in the receiveValue closure is executed, but the receiveCompletion is never called. The reason for this is that NotificationCenter publisher can send an infinite number of notifications to its subscribers.

///If you remove the assignment of subscription by removing subscription = before publisher.sink you will find that the receiveValue closure is never called due to the subscription being discarded as soon as the subscribe() function is done executing.
///
///ou can also explicitly cancel a subscription by calling cancel() on the AnyCancellable that contains the subscription, or directly on any object that conforms to Cancellable.
///
subscription?.cancel()
NotificationCenter.default.post(Notification(name: UIApplication.keyboardDidShowNotification))

