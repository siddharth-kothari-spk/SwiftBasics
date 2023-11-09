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
