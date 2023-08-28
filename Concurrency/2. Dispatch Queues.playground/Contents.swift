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
