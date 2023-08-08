import UIKit
// courtsey: https://www.avanderlee.com/concurrency/tasks/
// A task allows us to create a concurrent environment from a non-concurrent method, calling methods using async/await.

let sampleTask = Task {
    return "sample task"
}

print(await sampleTask.value)



// Task with error
enum SampleError: Error {
    case basicError
}

let valueToTest = 11

let sampleTask2 = Task {
    if valueToTest % 2 != 0 {
        throw SampleError.basicError
    }
    return "\(valueToTest) is divided by 2"
}

do {
    print(try await sampleTask2.value)
} catch {
    print("Basic task failed with error: \(error)")
}

//------------------------------------------------------
// We need a task to perform any async methods within a function that does not support concurrency.

func asyncSample() async {
    // some async stuff
    print("some async stuff")
}

func callingAsync() { // it is a non-async function
   //await asyncSample() // error : 'async' call in a function that does not support concurrency.
    
    /// To make it work, either we make callingAsync method by using 'async' keyword , but we have better way to handle it. using 'Task'
    Task {
        await asyncSample()
    }
}
callingAsync()
//------------------------------------------------------

// Cancellation
/// 1.- Checking the `isCancelled` value of the current `Task` inside `next()`
///   and returning `nil` to terminate the sequence.


let asyncTaskCancel1 = Task { () -> UIImage? in
    let imageURL = URL(string: "testURL")!
    
    guard Task.isCancelled else {
        print("Starting network request...")
        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
        return UIImage(data: imageData)
    }
    // any cleanup can be done here
    print("Image request was cancelled")
    return nil
}

/// 2. - Calling `checkCancellation()` on the `Task`, which throws a
///   `CancellationError`.
let asyncTaskCancel2 = Task { () -> UIImage? in
    let imageURL = URL(string: "testURL")!
    
    try Task.checkCancellation()
    print("Starting network request...")
        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
        return UIImage(data: imageData)
}

/// 3. - Implementing `next()` with a
///   `withTaskCancellationHandler(handler:operation:)` invocation to
///   immediately react to cancellation.
///   courtsey: https://forums.swift.org/t/how-to-use-withtaskcancellationhandler-properly/54341/7

let asyncTaskCancel3 = Task { () -> UIImage? in
    let imageURL = URL(string: "testURL")!
    
    let testTask = Task { print("onCancel")}
    let onCancel = { testTask.cancel()}
    
    return try await withTaskCancellationHandler(operation: {
        let imageURL = URL(string: "testURL")!
        print("Starting network request...")
        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
        return UIImage(data: imageData)
    }, onCancel: {
        onCancel()
    })
}
