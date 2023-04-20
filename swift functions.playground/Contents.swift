import UIKit

//1. Function with variadic parameters
/*
Sometimes, we do not know in advance the number of arguments that will be passed into a function. To handle this kind of situation, we can use variadic parameters in Swift.

Variadic parameters allow us to pass a varying number of values during a function call.

We use the ... character after the parameter's type to denote the variadic parameters.
*/

// program to find sum of multiple numbers


func sum( numbers: Int...) {

  var result = 0
  for num in numbers {
    result = result + num
  }
  
  print("Sum = \(result)")
}

// function call with 3 arguments
sum(numbers: 1, 2, 3)

// function call with 2 arguments
sum (numbers: 4, 9)




// 2. Function With inout Parameters

func changeName(name: inout String) {
  if name == "Ross" {
      name = "Joey"
  }
}

var userName = "Ross"
print("Before: ", userName)

changeName(name: &userName)

print("After: ", userName)


// 3. Multiple return values

func compute(number: Int) -> (Int, Int, Int) {

  var square = number * number

  var cube = square * number
  
  return (number, square, cube)
}

var result = compute(number: 5)

print("Number:", result.0)
print("Square:", result.1)
print("Cube:", result.2)



// 4. Nested Function with Return Values

func operate(symbol: String) -> (Int, Int) -> Int {

  // inner function to add two numbers
  func add(num1:Int, num2:Int) -> Int {
    return num1 + num2
  }

  // inner function to subtract two numbers
  func subtract(num1:Int, num2:Int) -> Int {
    return num1 - num2
  }

  let operation = (symbol == "+") ?  add : subtract
  return operation
}

let operation = operate(symbol: "+")
let operationResult = operation(8, 3)
print("Result:", operationResult)




// 5. Range


// 5.1 Close range
// 1...4 is close range
for numbers in 1...4 {
  print(numbers)
}

// 5.2 Half open range
for numbers in 1..<4 {
  print(numbers)
}

// 5.3 one sided range
// one-sided range using
// ..< operator
let range1 = ..<2

// check if -9 is in the range
print(range1.contains(-9))

// one-sided range using
// ... operator
let range2 = 2...

// check if 33 is in the range
print(range2.contains(33))




// 6. Function overloading with Argument Label


func display(person1 age:Int) {
    print("Person1 Age:", age)
}

func display(person2 age:Int) {
    print("Person2 Age:", age)
}

display(person1: 25)

display(person2: 38)

/* In the above example, two functions with the same name display() have the same number and the same type of parameters. However, we are still able to overload the function.

It is because, in Swift, we can also overload the function by using argument labels.

Here, two functions have different argument labels. And, based on the argument label used during the function call, the corresponding function is called.
*/

