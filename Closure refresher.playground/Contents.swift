import Foundation

/// Courtsey : https://gist.github.com/sabapathyk7/525ae7cce276488de19a8cc7514fc6e4
/*
    
    Closures are the self-contained blocks that can be passed around and used the code.
    Capture the values and store a reference to any constants and variables
    */
    
    /*
    Syntax
    { (<#parameters#>) -> <#return type#> in
    
    }
    */


//Capturing Values
    
    /*
    Closure can capture constants and variables from the context
    
    Simplest form of closure that capture values is nested function
    Nested function can capture values from outer function and inside the function
    
    */
    
    
    func addCount(forCount amount: Int) -> () -> Int {
        var total = 0
        func counter() -> Int {
            total += amount
            return total
        }
        return counter
    }
    print(addCount(forCount: 10)) // returns "(Function)"
    // counter doesn't have any paramter but returns Int value

// Capturing by reference
    // Swift handles memory managemnet involved for capturing values
    
    let countByTen = addCount(forCount: 10)
    print(countByTen()) //prints 10

// Functions and Closure are Reference Types

let addCountbyTen = countByTen
print(addCountbyTen()) // prints 20

print(countByTen()) // prints 30

/*
    Trailing Closure - Special syntax - Rather than passing in your closure as parameter, you can pass after the function inside the braces()
    
    
    */
    
    func closure(action: () -> Void) {
        print("1.")
        action()
        print("end of function")
    }

    closure {
        print("2.")
    }

/* Output
 1.
 2.
 end of function
*/

    func closure(action: (String) -> Void) {
            print("3.")
            action("Sid")
            print("end of function")
        }

    closure { str in
        print(str)
    }
/* Output
 3.
 Sid
 end of function
 */

    func makeAddOfTwoNumbers(digits: (Int, Int), onCompletion: (Int) -> Void) {
            print("4.")
            let sum = digits.0 + digits.1
            onCompletion(sum)
            print("end of function")
        }

    makeAddOfTwoNumbers(digits: (7,9)) { sum in
        print(sum)
    }

/* Output
 4.
 16
 end of function
 */

func closure2(action: (String) -> String) {
    print("5.")
    print(action("Sid"))
    print("end of function")
    }
    
    closure2 { str in
    "return \(str)"
    }
// shorthand
    closure2 {
        "Catching \($0) value"
    }

/*
 5.
 return Sid
 end of function
 5.
 Catching Saba value
 end of function
 */


// Multiple Arguments
    
    func closure3(action: (String, Int) -> String) {
    print("6.")
    print(action("Sid", 7))
    print("end of function")
    }
    closure3 { str, value in
    return "\(str) fav number is \(value)"
    }
    
    closure3 {
    "My name is \($0) and my fav number is \($1)"
    }

/*
 6.
 Sid fav number is 7
 end of function
 6.
 My name is Sid and my fav number is 7
 end of function
 */

/*
    Closure Types
    - Global Functions
    - Nested Functions
    - Closure Expressions
*/

// Closure Expression -
    
    let closureEx: (Int) -> String = { number in
        return "number is \(number)"
    }
    print(closureEx(7))


// Capturing Values in a Closure
    
    func incrementer(amount: Int) -> () -> Int {
        var total = 2
        let increment: () -> Int = {
            total += amount
            return total
        }
        return increment
    }
    let value = incrementer(amount: 7)
    print(value()) // 9
    print(value()) // 16
    print(value()) // 23


/* Non-escaping closures
    
    Default Closures
    Preserved to be executed later
 
    Lifecycle of the non-escaping closure:
    1. Pass the closure as a function argument
    2. Do additional work and execute
    3. Function returns.
 
    Benefits:
    - Immediate Callback
    - Synchronous Execution
    
*/

    func getSum(of array: [Int], completion: (Int) -> Void) {
            print("closure starts")
            var sum: Int = 0
            for i in 0..<array.count {
            sum += i
            }
            print(sum)
            completion(sum)
            print("closure ends")
        }
    getSum(of: [1,2,3,4,5]) { sum in
        print("SumArray \(sum)")
    }
/*
 closure starts
 10
 SumArray 10
 closure ends
 */
