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
