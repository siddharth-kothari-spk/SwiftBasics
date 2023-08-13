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

// Unowned Optional Reference

//We can use an unowned optional reference and a weak reference in the same contexts. The difference is that when you use an unowned optional reference, you’re responsible for making sure it always refers to a valid object or is set to nil.

class Train {
    let name: String
    var wagons: [Wagon] // Strong reference
    init(name: String) {
        self.name = name
        self.wagons = []
        print("Train \(name) initialized!")
    }
    deinit {
        print("Train \(name) deinitialized!")
    }
}

class Wagon {
    let type: String
    unowned var train: Train // Unowned reference
    unowned var nextWagon: Wagon? // Unowned Optional reference
    init (type: String, train: Train) {
        self.type = type
        self.train = train
        self.nextWagon = nil
        print("Wagon \(type) initialized!")
    }
    deinit {
        print("Wagon \(type) deinitialized!")
    }
}

var malabar: Train?
var economyWagon: Wagon?
var bussinessWagon: Wagon?
var excecutiveWagon: Wagon?

malabar = Train(name: "malabar")
economyWagon = Wagon(type: "economy", train: malabar!)
bussinessWagon = Wagon(type: "bussiness", train: malabar!)
excecutiveWagon = Wagon(type: "excecutive", train: malabar!)

economyWagon!.nextWagon = bussinessWagon
bussinessWagon!.nextWagon = excecutiveWagon

malabar!.wagons = [economyWagon!, bussinessWagon!, excecutiveWagon!]

malabar = nil
economyWagon = nil
bussinessWagon = nil
excecutiveWagon = nil

/* OUTPUT:

Train malabar initialized!
Wagon economy initialized!
Wagon bussiness initialized!
Wagon excecutive initialized!
Train malabar deinitialized!
Wagon economy deinitialized!
Wagon bussiness deinitialized!
Wagon excecutive deinitialized!

*/


// Unowned References and Implicitly Unwrapped Optional Properties
// This type of reference is best fit in a scenario where both properties should always have a value, and neither property should ever be nil once initialization is complete.

//In this scenario, we will combine an unowned property on one class with an implicitly unwrapped optional property on another class.

class Country {
    let name: String
    var capitalCity: City! // Implicitly Unwrapped Optional Property
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
        print("Country \(name) initialized!")
    }
    deinit {
        print("Country \(name) deinitialized!")
    }
}

class City {
    let name: String
    unowned let country: Country // Unowned reference
    init(name: String, country: Country) {
        self.name = name
        self.country = country
        print("City \(name) initialized!")
    }
    deinit {
        print("City \(name) deinitialized!")
    }
}

// The initializer for City is called from within the initializer for Country. However, the initializer for Country can’t pass self to the City initializer until a new Country instance is fully initialized, as described in Two-Phase Initialization (https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/#Two-Phase-Initialization)

// That’s why we declare the capitalCity property of Country as an implicitly unwrapped optional property (City!). This means that the default value of the capitalCity property is nil, like any other optional, but can be accessed without the need to unwrap its value as described in Implicitly Unwrapped Optionals (https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/#Implicitly-Unwrapped-Optionals)

// All of this means that we can create the Country and City instances in a single statement, without creating a strong reference cycle, and the capitalCity property can be accessed directly, without needing to use an exclamation point (!) to unwrap its optional value.

var country: Country?

country = Country(name: "Indonesia", capitalName: "Jakarta")
print("\(country!.name)'s capital city is called \(country!.capitalCity.name)")

country = nil

/* OUTPUT:

City Jakarta initialized!
Country Indonesia initialized!
Indonesia's capital city is called Jakarta
Country Indonesia deinitialized!
City Jakarta deinitialized!

*/

// Strong Reference Cycles for Closures

//Strong reference cycles could occur for closures as well. Because closures are reference types like classes. When you assign a closure to a property, you are assigning a reference to that closure. It’s the same problem, two strong references are keeping each other alive.

//The cycle can occur if you assign a closure to a property of a class instance, and the body of that closure captures the instance. This capture might occur because the closure’s body accesses a property or a method of the instance, such as self.someProperty or self.someMethod(). These accesses cause the closure to capture self, creating a strong reference cycle.

class PhoneNumber {
    let countryCode: String
    let number: String?
    
    // Closure captures self, creating a strong reference cycle
    lazy var fullNumber: () -> String = {
        if let safeNumber = self.number {
            return "\(self.countryCode)\(safeNumber)"
        } else {
            return "\(self.countryCode) empty number"
        }
    }
    
    init(countryCode: String, number: String? = nil) {
        self.countryCode = countryCode
        self.number = number
        print("\(self.countryCode) initialized with number \(String(describing: self.number))")
    }
    
    deinit {
        print("\(countryCode) deinitialized")
    }
}


var phoneNumber: PhoneNumber?
phoneNumber = PhoneNumber(countryCode: "+62", number: "987654321")
print(phoneNumber!.fullNumber())
phoneNumber = nil

/* OUTPUT:
 +62 initialized with number 987654321

+62987654321

*/

// To solve cycles in closures, we can use closure capture list.
class PhoneNumber2 {
    let countryCode: String
    let number: String?
    
    lazy var fullNumber: () -> String = {
        [unowned self] in // Capture self as unowned
        if let safeNumber = self.number {
            return "\(self.countryCode)\(safeNumber)"
        } else {
            return "\(self.countryCode) empty number"
        }
    }
    
    init(countryCode: String, number: String? = nil) {
        self.countryCode = countryCode
        self.number = number
    }
    
    deinit {
        print("\(countryCode) deinitialized")
    }
}

var phoneNumber2: PhoneNumber2?
phoneNumber2 = PhoneNumber2(countryCode: "+62", number: "987654321")
print(phoneNumber2!.fullNumber())
phoneNumber2 = nil

/* OUTPUT:

+62987654321
+62 deinitialized

*/
