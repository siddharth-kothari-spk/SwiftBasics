import UIKit

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

