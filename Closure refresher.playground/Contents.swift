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
            action("Saba")
            print("end of function")
        }

    closure { str in
        print(str)
    }
/* Output
 3.
 Saba
 end of function
 */
