import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// manual creation of thread
class CustomThread {
    func createThread() {
        let thread: Thread = Thread(target: self, selector: #selector(threadSelector), object: nil)
        thread.start()
    }
    
    @objc func threadSelector() {
        print("custom thread")
    }
    
}

let customThread = CustomThread()
customThread.createThread()

// DispatchQueue

var counter = 1
DispatchQueue.main.async {
    for i in 0...3 {
        counter = i
        print("\(counter)")
    }
}

for i in 4...6 {
    counter = i
    print("\(counter)")
}

DispatchQueue.main.async {
    counter = 100
    print("\(counter)")
}
