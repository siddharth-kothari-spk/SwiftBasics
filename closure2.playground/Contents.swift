import UIKit


// basic closure
var greeting = {
    print("hello")
}
greeting()


// closure with parameter
var greetingWhom = {(name: String) in
    print("hello \(name)")
}

greetingWhom("test")

// closure with parameter and return
var returnClosure = {(num1:Int, num2:Int) -> Int in
    return num1 * num2
}

print(returnClosure(3,6))



var name = "Sid"

let closure1 = {
    print("closure1 : \(name)")
}

closure1() // prints- closure1 : Sid

let closure2 = { [name]
    print("closure2 : \(name)")
}
name = "Sid2"
closure2() // prints- closure2 : Sid2


let closure3 = { [name] in
    print("closure3 : \(name)")
}
name = "Sid3"
closure3() // prints- closure3 : Sid2
// in closure3 a separate copy on name variable is made when closure3 is defined . so at this moment , it has value "Sid2" , now after changing name will not have any effect on closure3 name variable.


var tech = "iOS"
var stack = "mobile"

let closure4 = { [tech] in
    print("tech = \(tech) ; stack = \(stack)")
}

stack = "mobile app dev"
closure4() // prints - tech = iOS ; stack = mobile app dev



func execute() -> (Int) -> Int {
    var input = 0
    
    return { output in
        input += output
        return input
        
    }
}

let c1 = execute() // input - 0

let a = c1(5) // output - 5  , input - 0 which makes input - 5
let b = c1(10) // output - 10  , input - 5 which makes input - 15
let c = c1(15) // output - 15  , input - 15 which makes input - 30

print(c) // prints- 30

