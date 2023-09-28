// https://betterprogramming.pub/operationqueue-asynchronous-code-d383848e8ba4
import Foundation

/*
 In Swift using OperationQueue for asynchronous code may seem like pure hell because, under the hood, Operations are considered complete if the compilation of their synchronous code is completed.

 In other words, compiling the example described below will output a broken execution order since, by the time the asynchronous code is executed, the Operation itself will have already been completed.
 */

let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 1

operationQueue.addOperation {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        print("First async operation complete")
    }
    print("First sync operation complete")
}

operationQueue.addOperation {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        print("Second async operation complete")
    }
    print("Second sync operation complete")
}

/*
 First sync operation complete
 Second sync operation complete
 First async operation complete
 Second async operation complete
 */

/*
 The Operation itself has four flags by which you can track the life cycle of the operation:

     isReady — indicates whether the Operation can be performed at this time.
     isExecuting —indicates whether an Operation is currently in progress.
     isFinished —indicates whether the Operation is currently completed.
     isCancelled —indicates whether the Operation was cancelled.

 In theory, the Operation enters the isFinished state before the Operation itself is executed asynchronously, so we need to develop a technique by which we will be able to manipulate the life cycle of the Operation.
 */


