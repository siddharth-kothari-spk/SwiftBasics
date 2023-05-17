import UIKit

// Serial Queue
/*
 
 A serial Dispatch Queue performs only one task at the time. Serial queues are often used to synchronize access to a specific value or resource to prevent data races to occur.
 
*/

let serialQueue = DispatchQueue(label: "siddharth.serial.queue")

serialQueue.async {
    print("serialQueue Task 1 started")
    // Do some work..
    print("serialQueue Task 1 finished")
}
serialQueue.async {
    print("serialQueue Task 2 started")
    // Do some work..
    print("serialQueue Task 2 finished")
}


/*
 What is a concurrent queue?

 A concurrent queue allows us to execute multiple tasks at the same time. Tasks will always start in the order they’re added but they can finish in a different order as they can be executed in parallel. Tasks will run on distinct threads that are managed by the dispatch queue. The number of tasks running at the same time is variable and depends on system conditions.
*/

let concurrentQueue = DispatchQueue(label: "siddharth.concurrent.queue", attributes: .concurrent)

concurrentQueue.async {
    print("Task 1 started")
    // Do some work..
    print("Task 1 finished")
}
concurrentQueue.async {
    print("Task 2 started")
    // Do some work..
    print("Task 2 finished")
}



/*
The best of both worlds

In some cases, it’s valuable to benefit from the concurrent queue to perform multiple tasks at the same time while still preventing data races. This is possible by making use of a so-called barrier. Before we dive in, it’s good to know what a data race exactly is.
What is a data race?

A data race can occur when multiple threads access the same memory without synchronization and at least one access is a write. You could be reading values from an array from the main thread while a background thread is adding new values to that same array.

Data races can be the root cause behind flaky tests and weird crashes. Therefore, it’s good practice to regularly spend time using the Thread Sanitizer.
Using a barrier on a concurrent queue to synchronize writes

A barrier flag can be used to make access to a certain resource or value thread-safe. We synchronize write access while we keep the benefit of reading concurrently.

The following code demonstrates a messenger class that can be accessed from multiple threads at the same time. Adding new messages to the array is done using the barrier flag which blocks new reads until the write is finished.
*/



final class Messenger {

    private var messages: [String] = []

    private var queue = DispatchQueue(label: "messages.queue", attributes: .concurrent)

    var lastMessage: String? {
        return queue.sync {
            messages.last
        }
    }

    func postMessage(_ newMessage: String) {
        queue.sync(flags: .barrier) {
            messages.append(newMessage)
        }
    }
}

let messenger = Messenger()
// Executed on Thread #1
messenger.postMessage("Hello Siddharth!")
// Executed on Thread #2
print(messenger.lastMessage) // Prints: Hello Siddharth!




/*
 How to prevent excessive thread creation?

 It’s best practice to make use of the global concurrent dispatch queues. This prevents you from creating too many private concurrent queues. Apart from this, you should still be conscious of executing long-blocking tasks.

 You can make use of the global concurrent queue as follows:
*/
 DispatchQueue.global().async {
     /// Concurrently execute a task using the global concurrent queue. Also known as the background queue.
 }

// This global concurrent queue is also known as the background queue and used next to the DispatchQueue.main.

