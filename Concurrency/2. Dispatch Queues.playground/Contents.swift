import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
/*
DispatchQueue.main.async {
    print(Thread.isMainThread ? "Main thread" : "Not main thread")
}

DispatchQueue.global().async {
    print(Thread.isMainThread ? "Main thread" : "global concurrent queue")
}


DispatchQueue.global(qos: .userInteractive).async {
    print(Thread.isMainThread ? "Main thread" : "global concurrent queue - userInteractive")
}
*/
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
