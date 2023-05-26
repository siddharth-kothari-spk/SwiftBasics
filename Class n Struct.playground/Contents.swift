import UIKit

// 1. Classes are of reference type. This means each instance of a class shares the same copy of data. For example,


class BikeClass {
  var color: String

  init(color:String) {
    self.color = color
  }
}

var bikeClass1 = BikeClass(color: "Blue")

var bikeClass2 = bikeClass1

bikeClass1.color = "Red"
print(bikeClass2.color)  // prints Red




// On the other hand, structs are of the value type. This means each instance of a struct will have an independent copy of data. For example,

struct BikeStruct {
  var color: String

  init(color:String) {
    self.color = color
  }
}

var bikeStruct1 = BikeStruct(color: "Blue")

var bikeStruct2 = bikeStruct1

bikeStruct1.color = "Red"
print(bikeStruct2.color)  // prints blue



// Swift Computed Property

class Calculator1 {

  // define two stored properties
  var num1: Int = 0
  var num2: Int = 0

    init(num1: Int, num2: Int) {
        self.num1 = num1
        self.num2 = num2
    }
  // define one computed property
  var sum: Int {
    // calculate value
    num1 + num2
  }
}

var object1 = Calculator1(num1: 11, num2: 12)

// read value of computed property
print("Sum:", object1.sum)




//Getters And Setters for Computed Properties

/*In Swift, we can also include a getter and setter inside a computed property.

    getter - returns the computed value
    setter - changes the value
*/

class Calculator2 {
  var num1: Int = 0
  var num2: Int = 0

    init(num1: Int, num2: Int) {
        self.num1 = num1
        self.num2 = num2
    }
    
  // create computed property
  var sum: Int {
    // retrieve value
    get {
      num1 + num2
    }
    // set new value to num1 and num2
    set(modify) {
      num1 = (modify + 10)
      num2 = (modify + 20)
    }
  }
}

var object2 = Calculator2(num1: 20, num2: 50)

// get value
print("Get value:", object2.sum)

// provide value to modify
object2.sum = 5

print("New num1 value:", object2.num1)
print("New num2 value:", object2.num2)





// Swift Static Properties

/*In the previous example, we have used objects of the class to access its properties. However, we can also create properties that can be accessed and modified without creating objects.

These types of properties are called static properties. In Swift, we use the static keyword to create a static property.
 
 Similarly, we can also create static properties inside a struct. static properties inside a struct are of a struct type, so we use the struct name to access them.
*/

class University {

 // static property
 static var name: String = ""

 // non-static property
 var founded: Int = 0
}

// create an object of University class
var uniObj = University()

// assign value to static property
University.name = "Kathmandu University"
print(University.name)

// assign value to non-static property
uniObj.founded = 1991
print(uniObj.founded)



// Swift mutating Methods
//In Swift, if we declare properties inside a class or struct, we cannot modify them inside the methods. For example,
/*
struct Employee {

  var salary = 0.0
  
  func salaryIncrement() {
    // Error Code
    salary = salary * 1.5 // Cannot assign to property: 'self' is immutable
  }
*/
//Here, since struct is a value type, if we try to modify the value of salary, we'll get an error message.

struct Employee {
  var salary = 0
  
  // define mutating function
  mutating func salaryIncrement(increase: Int) {
  // modify salary property
  salary = salary + increase
  print("Increased Salary:",salary)
  }
}

var employee1 = Employee()
employee1.salary = 20000
employee1.salaryIncrement(increase: 5000)

