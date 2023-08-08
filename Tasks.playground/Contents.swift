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
