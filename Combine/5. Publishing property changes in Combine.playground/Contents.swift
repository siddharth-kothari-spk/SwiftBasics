/// courtsey: https://www.donnywals.com/publishing-property-changes-in-combine/
/// In Combine, everything is considered a stream of values that are emitted over time. This means that sometimes a publisher can publish many values, and other times it publishes only a single value. And other times it errors and publishes no values at all. When your UI has to respond to changing data, or if you want to update your UI in response to a user's actions, you might consider the data and user input to both be streams of values.
import Combine
import Foundation

// There are no dedicated publishers for your own objects and properties. There are, however, publishers that allow you to publish objects of a certain type at will. These publishers are the PassthroughSubject and CurrentValueSubject publishers.

// 1. Using a PassthroughSubject to publish values
var stringSubject = PassthroughSubject<String, Never>()
stringSubject.sink { value in
    print("Received value: \(value)")
}

stringSubject.send("Sid")
stringSubject.send("Kots")

// Notification sample as PassthroughSubject
let notificationSubject = PassthroughSubject<Notification, Never>()

let notificationName = Notification.Name("MyNotification")
let center = NotificationCenter.default
center.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
  notificationSubject.send(notification)
}

notificationSubject.sink(receiveValue: { notification in
  print("received notification: \(notification)")
})

center.post(name: notificationName, object: nil, userInfo: ["Hello": "World!"])
