import UIKit
import Foundation
///courtsey: https://ersoya.medium.com/concurrency-grand-central-dispatch-in-swift-13d7e2562d01
///
/// Multitasking allows us to run several tasks simultaneously. GCD (Grand Central Dispatch) is the simplest way to achieve multitasking in iOS.

// GCD operates on dispatch queues through a class named DispatchQueue. Queues can be either serial or concurrent.

//Serial queues guarantee that only one task runs at any given time. GCD controls the execution timing. Concurrent queues allow multiple tasks to run at the same time. The queue guarantees tasks start in the order you add them. Tasks can finish in any order.

// Simple Task
//print("Simple Task")
func simpleTask() {
    let queue = DispatchQueue(label:"simpleTask")
    queue.async {
        for i in 1...5 {
            print("square of \(i) is \(i*i)")
        }
    }
}

//simpleTask()
//print("-------------------------------------------")


// Sync
//print("Synchronous task")
func syncTask() {
    let queue = DispatchQueue(label:"syncTask")
    queue.sync {
        for i in 1...5 {
            print("op inside sync queue \(i)")
        }
    }
    
    for i in 1...5 {
        print("op outside sync queue \(i)")
    }
}
//syncTask()

// Async
//print("Asynchronous task")
func asyncTask() {
    let queue = DispatchQueue(label:"asyncTask")
    queue.async {
        for i in 1...5 {
            print("op inside async queue \(i)")
        }
    }
    
    for i in 1...5 {
        print("op outside async queue \(i)")
    }
}
//asyncTask()


// Concurrent task - In concurrent mode, tasks in the queue get dispatched one after another and starts execution immediately and task completes their execution in any order.
//print("Concurrent task")
func concurrentTask() {
    let queue = DispatchQueue(label:"concurrentTask", attributes: .concurrent)
    
    queue.async {
        for i in 1...5 {
            print("task1 op inside async queue \(i)")
        }
    }
    
    queue.async {
        for i in 1...5 {
            print("task2 op inside async queue \(i)")
        }
    }

}
//concurrentTask()


// Specifying Priority on Task Queues
 /*
  .userInteractive -> We use this for UI updates, event handling and small workloads that require low latency. This should run on the main thread.
    .userInitiated -> We can use this when the user is waiting for results and for tasks which are required to continue user interaction. This runs in the high priority global queue.
    .default
    .utility -> This represents long-running tasks such as a progress indicator which is visible during computations, networking, continuous data fetching, etc. This runs in the low priority global queue.
    .background -> This represents tasks that users are not aware of such as prefetching, maintenance, and other tasks that don’t require user interaction and aren’t time-sensitive. This has the lowest priority.
    .unspecified
*/
//print("qualityOfService")
func qualityOfService() {
    let userInitiatedQueue = DispatchQueue(label: "userInitiatedQueue", qos: .userInitiated)
    let backgroundQueue = DispatchQueue(label: "backgroundQueue", qos: .background)
    
    backgroundQueue.async {
        for i in 1...5 {
            print("backgroundQueue op inside async queue \(i)")
        }
    }
    
    userInitiatedQueue.async {
        for i in 1...5 {
            print("userInitiatedQueue op inside async queue \(i)")
        }
    }
}

// we write backgroundQueue.async block before userInitiatedQueue.async block, userInitiatedQueue task will finish earlier than the backgroundQueue.

//qualityOfService()


// Global queue : default background queue
//print("globalQueue")
func globalQueue() {
    let queue = DispatchQueue.global()
    
    queue.async {
        for i in 1...5 {
            print("globalQueue op inside async queue \(i)")
        }
    }
}
//globalQueue()

// Main Queue : We should not perform UI related operations on a background queue or queue other than the main queue.
//print("main queue")
func mainQueue() {
    DispatchQueue.main.async(execute: Dispatch.DispatchWorkItem(block: {
        print("mainQueue")
    }))
}
//mainQueue()

// Delay task
//print("Delay execution")
func delayExecution() {
    let queue = DispatchQueue(label: "delay queue")
    print(Date())
    
    queue.asyncAfter(deadline: .now() + 5, execute: DispatchWorkItem(block: {
        print(Date()) // prints after 5 sec
    }))
}
//delayExecution()


//Concurrent perform : DispatchQueue provides us with a convenient method to execute the same task concurrently for several iterations.
func concurrentPerform() {
    DispatchQueue.concurrentPerform(iterations: 5) { value in
        print(value)
    }
}

//concurrentPerform()

// DispatchGroup  is a way to block a thread until one or more tasks finish executing. You can use this behaviour in places where you cannot make progress until all of the specified tasks are completed.

func dispatchGroupSample() {
    let queue = DispatchQueue(label: "dispatch group", attributes: .concurrent)
    let group = DispatchGroup()
    
    queue.async {
        for i in 1...5 {
            print("task1 outside group index \(i)")
        }
    }
    
    group.enter()
    queue.async {
        for i in 1...5 {
            print("task2 index \(i)")
        }
        group.leave()
    }
    
    group.enter()
    queue.async {
        for i in 1...5 {
            print("task3 index \(i)")
        }
        group.leave()
    }
    
    group.wait()
    
    // task4 will only start till all items inside group are complete
    queue.async {
        for i in 1...5 {
            print("task4 outside group index \(i)")
        }
    }
}
dispatchGroupSample()
