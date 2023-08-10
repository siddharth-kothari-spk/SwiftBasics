/// courtsey: https://ersoya.medium.com/dispatch-barrier-in-swift-5613589ce53e

import UIKit

let queue = DispatchQueue(label: "barrier", attributes: .concurrent)

queue.async {
    for index in 0..<5 {
        sleep(1)
        print("Task 1: async \(index)")
    }
}

queue.sync {
    for index in 0..<5 {
        sleep(1)
        print("Task 2: sync before barrier \(index)")
    }
}

queue.sync(flags: .barrier, execute: {
    for index in 5..<10 {
        sleep(1)
        print("Task 3: sync after barrier \(index)")
    }
})

queue.async {
    for index in 5..<10 {
        sleep(1)
        print("Task 4: async \(index)")
    }
}

/* sample output
 Task 2: sync before barrier 0
 Task 1: async 0
 Task 2: sync before barrier 1
 Task 1: async 1
 Task 2: sync before barrier 2
 Task 1: async 2
 Task 2: sync before barrier 3
 Task 1: async 3
 Task 2: sync before barrier 4
 Task 1: async 4
 Task 3: sync after barrier 5
 Task 3: sync after barrier 6
 Task 3: sync after barrier 7
 Task 3: sync after barrier 8
 Task 3: sync after barrier 9
 Task 4: async 5
 Task 4: async 6
 Task 4: async 7
 Task 4: async 8
 Task 4: async 9
 */
