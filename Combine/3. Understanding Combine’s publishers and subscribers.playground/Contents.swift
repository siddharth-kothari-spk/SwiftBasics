/// courtsey: https://www.donnywals.com/understanding-combines-publishers-and-subscribers/
///
import Combine

/// publishers send values to their subscribers, and that a publisher can emit one or more values, but that they only emit a single completion (or error) event.
/// A publisher/subscriber relationship in Combine is solidified in a third object, the subscription. When a subscriber is created and subscribes to a publisher, the publisher will create a subscription object and it passes a reference of the subscription to the subscriber.
/// The subscriber will then request a number of values from the subscription in order to begin receiving those values. This is done by calling request(_:) on the subscription
/// When a new value is generated for a publisher, it's the subscription's job to mediate between the publisher and the subscriber and to make sure that subscribers don't receive more values than they request. Subscriptions are also responsible for retaining and releasing subscribers
///
///
///

// 1. Creating a custom subscriber
/// subscribers request (or demand) a number of values from a subscription object.
/// publisher receives a subscriber, creates a subscription and ties the subscription and subscriber together.

public protocol Subscriber : CustomCombineIdentifierConvertible {

  associatedtype Input
  associatedtype Failure : Error

  func receive(subscription: Subscription) // i)
  func receive(_ input: Self.Input) -> Subscribers.Demand // ii)
  func receive(completion: Subscribers.Completion<Self.Failure>) // iii)
}

//The Subscriber protocol has two associated types, Input and Failure. The concrete values for these associated types must match those of the publisher that it wants to subscribe to.

// i) The first, receive(subscription:) is called when a publisher creates and assigns a subscription object to the subscriber. At that point, the subscriber communicates its initial demand to the subscription.

// ii) receive(_:) is called every time the subscription pushes a new object to the subscriber. The subscriber returns a Subscription.Demand to the subscription to communicate the number of items it wants to receive now.  this demand is added to any demands that were sent to the subscription earlier.

// iii) When the final value is generated, the subscription will call receive(completion:) with the result of the sequence. This method is only called once and concludes the stream of new values.


// Int Subscriber
class IntSubscriber: Subscriber {
    typealias Input = Int // This subscriber will only work on publishers that emit Int values
    
    typealias Failure = Never // we don't expect publishers that this subscriber subscribes to emit failures
    
    func receive(subscription: Subscription) {
        print("received subscription")
        subscription.request(.max(1)) // subscriber wants to receive a single value
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("received input: \(input)")
        return .none // we don't want to alter the demand of this publisher when we receive a new value.
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("received completion: \(completion)") // called when the subscriber finishes
    }
}
