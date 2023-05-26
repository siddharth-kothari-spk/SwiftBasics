import UIKit

struct ExampleDispatchWorkItem {
    // sample
    func myDispatchWorkItem() {
        print("myDispatchWorkItem")
        
        var number : Int = 19
        let workItem = DispatchWorkItem {
            number += 1
        }
        
        workItem.notify(queue: .main, execute: {
            debugPrint("number incremented to value = \(number)")
        })
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: workItem)
    }
    
    // cancellable work item sample
    
    func printNumbers() {
        // keeping it "let" gives error : "Constant 'workItem' captured by a closure before being initialized"
       // let workItem : DispatchWorkItem?
        
        var workItem : DispatchWorkItem?

        workItem = DispatchWorkItem {
            
            for i in 1...10 {
                guard let wkItem = workItem, !wkItem.isCancelled else {
                    debugPrint("workitem is cancelled")
                    break
                }
                debugPrint("\(i)")
                sleep(1)
            }
        }
        
        workItem?.notify(queue: .main, execute: {
            debugPrint("done printing numbers")
        })
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: workItem!)
        
        queue.asyncAfter(deadline: .now() + .seconds(3), execute: {
            workItem?.cancel()
        })
    }
}

let obj = ExampleDispatchWorkItem()
//obj.myDispatchWorkItem()

obj.printNumbers()
