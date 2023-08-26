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
