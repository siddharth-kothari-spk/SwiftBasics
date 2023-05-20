import UIKit

protocol Greet {
  
  // blueprint of property
  var name: String { get }

  // blueprint of a method
  func message()
}

// conform class to Greet protocol
class Employee: Greet {

  // implementation of property
  var name = "Perry"

  // implementation of method
  func message() {
    print("Good Morning", name)
  }
}

var employee1 = Employee()
employee1.message()



//Protocol Extensions

//In Swift, we can extend protocols using the extension keyword.


// protocol definition
protocol Brake {
  func applyBrake()
}

// define class that conforms Brake
class Car: Brake {
  var speed: Int = 0

  func applyBrake() {
    print("Brake Applied")
  }
}

// extend protocol
extension Brake {
  func stop() {
    print("Engine Stopped")
  }
}

let car1 = Car()
car1.speed = 61
print("Speed:", car1.speed)

car1.applyBrake()

// access extended protocol
car1.stop()




struct Employee1: Hashable {
  var name: String
}

var object1 = Employee1(name: "Sid")
let object2 = Employee1(name: "Sid")

// print hash values
print(object1.hashValue)
print(object2.hashValue)

print(object1 == object2)

let object3 = object1
print(object3.hashValue)

object1.name = "Nik"
print(object1.hashValue)
print(object2.hashValue)
print(object3.hashValue)
