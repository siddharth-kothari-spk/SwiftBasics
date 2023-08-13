/// courtsey: https://medium.com/@dimaswisodewo98/memory-management-in-swift-with-arc-strong-weak-unowned-679dc9b49dae
///
import UIKit


/// Memory management in Swift is handled by using Automatic Reference Counting or ARC, a memory management feature of the Clang compiler which is also used for Objective-C. Most of the time, ARC worked automatically. But, sometimes we need to consider relationships between objects to avoid memory leaks.

//---------------------------------
// ARC in Action
//----------------------------------

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) initialized!")
    }
    deinit {
        print("\(name) deinitialized!")
    }
}

Person(name: "person1") // the instance is allocated, then deallocated properly.
/* OUTPUT:

 person1 initialized!
 person1 deinitialized!

*/

// create a constant that references that instance
let person2 = Person(name: "person2") // instance is never deallocated because there is a strong reference to that instance, and the constant never leaves its scope

/* OUTPUT:

 person2 initialized!

*/

// create constant inside function
func test1() {
    let person3 = Person(name: "person3") // instance will be deallocated because the constant leaves its scope
}
test1()
/* OUTPUT:

 person3 initialized!
 person3 deinitialized!

*/


// multiple references
var ref1: Person?
var ref2: Person?
var ref3: Person?

ref1 = Person(name: "person4")
ref2 = ref1
ref3 = ref2

ref1 = nil
ref2 = nil

/* OUTPUT:

 person4 initialized!

*/
// instance is never deallocated because there is still a reference to that instance - ref3


//---------------------------------
// Strong Reference Cycles Between Class Instances
//---------------------------------

class Driver {
    let name: String
    var car: Car? // Strong reference
    init(name: String) {
        self.name = name
        print("\(name) initialized!")
    }
    deinit {
        print("\(name) deinitialized!")
    }
}

class Car {
    let type: String
    var owner: Driver? // Strong reference
    init(type: String) {
        self.type = type
        print("\(type) initialized!")
    }
    deinit {
        print("\(type) deinitialized!")
    }
}

// Not every person has a car, and not every car has an owner. The value of each car and owner property is nil initially.

var driver: Driver?
var honda: Car?

driver = Driver(name: "driver")
honda = Car(type: "honda")

driver!.car = honda
honda!.owner = driver

driver = nil
honda = nil

// Both instances will not be deallocated, because the reference count never reaches zero for both instances.
/* OUTPUT:

driver initialized!
honda initialized!

*/
