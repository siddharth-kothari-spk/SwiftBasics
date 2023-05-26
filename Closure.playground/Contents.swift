import UIKit

/*
 Here's the syntax to declare a closure:

 { (parameters) -> returnType in
    // statements
 }
 
 Here,

     parameters - any value passed to closure
     returnType - specifies the type of value returned by the closure
     in (optional) - used to separate parameters/returnType from closure body

 */


//1. Closure Parameters

//Similar to functions, a closure can also accept parameters.

// closure that accepts one parameter

let greetUser = { (name: String)  in
    print("Hey there, \(name).")
}

// closure call
greetUser("Delilah")


// 2. Closure That Returns Value

//A Swift closure may or may not return a value. If we want our closure to return some value, we need to mention it's return type and use the return statement.


var findSquare = { (num: Int) -> (Int) in
  var square = num * num
  return square
}

// closure call
var result = findSquare(3)

print("Square:",result)


// 3. Closures as Function Parameter

// define a function and pass closure
func grabLunch(search: ()->()) {
  print("Let's go out for lunch")

  // closure call
  search()
}

// pass closure as a parameter
grabLunch(search: {
   print("Alfredo's Pizza: 2 miles away")
})



// 4. Trailing Closure
/*
In trailing closure, if a function accepts a closure as its last parameter,

// function definition
func grabLunch(message: String, search: ()->()) {
  ...
}

We can call the function by passing closure as a function body without mentioning the name of the parameter. For example,

// calling the function
grabLunch(message:"Let's go out for lunch")  {
  // closure body
}

Here, everything inside the {...} is a closure body.
*/


func grabLunch(message: String, search: ()->()) {
   print(message)
   search()
}

// use of trailing closure
grabLunch(message:"Let's go out for lunch")  {
  print("Alfredo's Pizza: 2 miles away")
}




// Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages

// Non - escaping means that a closure will not remain in memory once the function that calls this closure finish execution. So closure needs to be executed before its calling function finish execution. Closure is non- escaping by default.



class TestClosure {
    
    func sample() {
        
    }
    
    func performAdd() {
        print("Step1")
        add(5, andNum2: 6) { result in
            sample()
            print(result)
        }
        print("Final")
    }
    
    func add(_ num1: Int, andNum2 num2: Int, completionHandler:(_ result: Int) -> Void) {
        print("Step2")
        let sum = num1 + num2
        print("Step3")
        completionHandler(sum)
    }
    
    func performSub() {
        print("Step1")
        sub(5, andNum2: 6) {[weak self] result in
           //  sample() // throws error : Call to method 'sample' in closure requires explicit use of 'self' to make capture semantics explicit
          //  self.sample() // no error , but this will cause memory issues as we now will keep strong reference so we  use weak self
            self?.sample() // now weak self is being used
            print(result)
        }
        print("Final")
    }
    
    func sub(_ num1: Int, andNum2 num2: Int, completionHandler:@escaping(_ result: Int) -> Void) {
        print("Step2")
        let sub = num1 - num2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // wait for 3 sec
            print("Step3")
            completionHandler(sub)
        }
        
    }
}


 let testClosure = TestClosure()
testClosure.performAdd() // prints Step1 -> Step2 -> Step3 -> 11 -> Final


// escaping means that a closure will remain in memory once the function that calls this closure finish execution. Generally used i API calls where code is running asynchronously and execution time is unknown. It takes more memory

testClosure.performSub() // prints Step1 -> Step2 -> Final - Step3 -> -1
