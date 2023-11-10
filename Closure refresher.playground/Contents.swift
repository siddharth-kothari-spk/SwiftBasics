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


/*
    Escaping Closures
    When passing closure as argument - preserved to be executed later and function's body gets executed returns the compiler back.
    As Execution ends, the scope exist and have existence in memory, till the closure gets executed
    
    Ways to escaping closure
    - Storage - Preserve the closure in storage in memory, part of the calling function get executed and return the compiler back
    - Asynchronous Execution - Executing the closure async on dispatch Queue, queue will hold the closure in memory, to be used for future. - No idea of when the closure gets executed

    Life Cycle
    - Pass the closure as function argument
    - Do additional work in func
    - Func execute async or stored
    - Func returns compiler back
*/

let url = URL(string: "https://www.geeksforgeeks.org/")!
let data = try? Data(contentsOf: url)


// Function to call the escaping closure
    func loadData(completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                completion(data)
            }
        }
    }

    loadData { data in
        guard data != nil else {
            // Handle error
            return
        }
    }
    
    // Print result
    print("Data loaded")


/*
    Autoclosures- Automatically created to wrap a piece of code. way to delay the execution of closure until it is actually needed.
    Autoclosures - used as arguments to functions where closure is optional or where closure's execution may not be necessary
    
    Swift Standard Library uses the following
    - assert(_:_:file:line:) Function
    assert(someCondition, "This condition should be true")
    - precondition(_:_:file:line:)
    precondition(someCondition, "This precondition should be true")
    - assertionFailure(_:_:file:line:)
    assertionFailure("This is a custom assertion failure message")
    
*/

    func logIfTrue(_ condition: @autoclosure() -> Bool) {
        if condition() {
            print("True")
        } else {
            print("False")
        }
    }
        
    logIfTrue("Sid" > "Nikku")

    // with escaping
    func delayedPrint(delay: Double, closure: @escaping () -> Void) {
        print("in func delayedPrint")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }

    print("Start")
    delayedPrint(delay: 2) {
        print("Hello World")
    }

/*
 Start
 in func delayedPrint
 Hello World
 */


    func delayedPrint(delay: Double, closure: @escaping @autoclosure () -> Void) {
            print("in func delayedPrint")
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                closure()
            }
        }

    print("Start 2")
    delayedPrint(delay: 5, closure: print("Hellow Sid"))

/*
 Start 2
 in func delayedPrint
 Hellow Sid
 */


// Typealias with Closure
    public typealias SimpleClosure = () -> ()
    func execute(closure: SimpleClosure) {
        print("Executing Closure")
        closure()
    }

    let helloClosure: SimpleClosure = {
        print("Hello World")
    }
    execute(closure: helloClosure)

/*
 Executing Closure
 Hello World
 */

public typealias SimpleClosure2 = (Int) -> ()
func execute2(closureA: SimpleClosure2) {
    print("Executing ClosureA")
    closureA(100)
}

let closureA1: SimpleClosure2 = {sum in
    print("Sum square = \(sum * sum)")
}

execute2(closureA: closureA1)

/*
Executing ClosureA
Sum square = 10000
*/
