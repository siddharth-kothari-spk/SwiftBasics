import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

DispatchQueue.main.async {
    print(Thread.isMainThread ? "Main thread" : "Not main thread")
}

DispatchQueue.global().async {
    print(Thread.isMainThread ? "Main thread" : "global concurrent queue")
}


DispatchQueue.global(qos: .userInteractive).async {
    print(Thread.isMainThread ? "Main thread" : "global concurrent queue - userInteractive")
}

//
DispatchQueue.global(qos: .background).async {
    for i in 11...21 {
        print(i)
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...10 {
        print(i)
    }
}


// target queue

let a = DispatchQueue(label: "A")
let b = DispatchQueue(label: "B", attributes: .concurrent, target: a)
// 'b' will act as serial queue as its target is 'a' and 'a' is a serial queue

a.async {
    for i in 1...5 {
        print(i)
    }
}

a.async {
    for i in 6...10 {
        print(i)
    }
}

b.async {
    for i in 11...15 {
        print(i)
    }
}

b.async {
    for i in 16...20 {
        print(i)
    }
}


let a1 = DispatchQueue(label: "A", attributes: .concurrent)
let b1 = DispatchQueue(label: "B", target: a1)
// 'b1' will act as concurrent queue as its target is 'a1' and 'a1' is a concurrent queue

a1.async {
    for i in 1...5 {
        print(i)
    }
}

a1.async {
    for i in 6...10 {
        print(i)
    }
}

b1.async {
    for i in 11...15 {
        print(i)
    }
}

b1.async {
    for i in 16...20 {
        print(i)
    }
}


let queueA = DispatchQueue(label: "queueA")
let queueB = DispatchQueue(label: "queueB")
//queueB.setTarget(queue: queueA) // error : cant set target once queue is already active


let queueC = DispatchQueue(label: "queueC")
let queueD = DispatchQueue(label: "queueD", attributes: .initiallyInactive, target: queueC)
queueD.setTarget(queue: queueC) // allowed as 'queueD' was initiallyInactive

let queueE = DispatchQueue(label: "queueE", attributes: [.concurrent, .initiallyInactive], target: queueC) // // allowed as 'queueE' was initiallyInactive
