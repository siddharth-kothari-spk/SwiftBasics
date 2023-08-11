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
print("Synchronous task")
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
syncTask()
