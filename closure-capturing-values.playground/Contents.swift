// https://iamankurjain.medium.com/uncovering-hidden-gems-in-swift-0e785b323dcf

/*
 Closures Capturing values

 In Swift, closures provide a powerful way to encapsulate functionality, allowing developers to create reusable units of code that can be passed around and executed at a later time. One intriguing aspect of closures is their ability to capture constants and variables from the surrounding context in which they’re defined. This means that closures can retain references to these values, even if the original scope where they were defined no longer exists. To illustrate this concept, let’s explore a scenario where we create a function factory using closures to generate custom calculator functions. Through this example, we’ll delve into how closures capture values from their enclosing scope, enabling the creation of dynamic and adaptable code structures
 */

func makeCal(initialValue: Int, operation: @escaping (Int) -> Int) -> () -> Int {
    var result = initialValue
    
    let calClosure: () -> Int = {
        result = operation(result)
        return result
    }
    
    return calClosure
}

let addCal = makeCal(initialValue: 0) { val in
    val + 5
}

print(addCal())
print(addCal())
print(addCal())


let squareCal = makeCal(initialValue: 2) { val in
    val * val
}

print(squareCal())
print(squareCal())
print(squareCal())

