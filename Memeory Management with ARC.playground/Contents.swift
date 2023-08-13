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
var car: Car?

driver = Driver(name: "driver")
car = Car(type: "honda")

driver!.car = car
car!.owner = driver

driver = nil
car = nil

// Both instances will not be deallocated, because the reference count never reaches zero for both instances.
/* OUTPUT:

driver initialized!
car initialized!

*/

// To resolve the strong reference cycles problem, we can use weak reference and unowned reference.

//The Driver and Car example shows a situation where two properties, both allowed to be nil, have the potential to cause a strong reference cycle. This scenario is best resolved with a weak reference.

class Driver2 {
    let name: String
    var car: Car2? // Strong reference
    init(name: String) {
        self.name = name
        print("\(name) initialized!")
    }
    deinit {
        print("\(name) deinitialized!")
    }
}

class Car2 {
    let type: String
    weak var owner: Driver2? // Weak reference
    init(type: String) {
        self.type = type
        print("\(type) initialized!")
    }
    deinit {
        print("\(type) deinitialized!")
    }
}

var driver2: Driver2?
var car2: Car2?

driver2 = Driver2(name: "driver2")
car2 = Car2(type: "honda2")

driver2!.car = car2
car2!.owner = driver2

driver2 = nil
car2 = nil

/* OUTPUT:

 driver2 initialized!
honda2 initialized!
 driver2 deinitialized!
honda2 deinitialized!

*/

// Let’s create a class named IdentityCard. In this case, a person may or may not have an identity card, but an identity card will always be associated with a person.

//The User and IdentityCard example shows a situation where one property that’s allowed to be nil and another property that can’t be nil, have the potential to cause a strong reference cycle. This scenario is best resolved with an unowned reference.

class User {
    let name: String
    var card: IdentityCard? // Strong reference
    init(name: String) {
        self.name = name
        print("\(name) initialized!")
    }
    deinit {
        print("\(name) deinitialized!")
    }
}

class IdentityCard {
    let number: UInt64
    unowned let owner: User // Unowned reference
    init(number: UInt64, owner: User) {
        self.number = number
        self.owner = owner
        print("Card \(number) initialized!")
    }
    deinit {
        print("Card \(number) deinitialized!")
    }
}

// when we set the User instance to nil, there will be no more strong references, and the instance will be deallocated.

var user: User?
var idCard: IdentityCard?

user = User(name: "user")
idCard = IdentityCard(number: 1234_5678_9012_3456, owner: user!)

user!.card = idCard

user = nil
idCard = nil

/* OUTPUT:

user initialized!
Card 1234567890123456 initialized!
user deinitialized!
Card 1234567890123456 deinitialized!

*/
