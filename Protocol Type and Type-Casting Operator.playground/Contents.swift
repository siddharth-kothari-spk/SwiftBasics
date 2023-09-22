// https://medium.com/@hyleedevelop/ios-q-a-how-to-store-different-classes-or-structures-into-one-array-d09d88916b39

// how to store different types of structs or classes in a single array

// Sol: Instances of different classes and structures can be stored in a single array by declaring a protocol as a common type and having both classes and structures conform that protocol.

import Foundation

// (1)
// Define Food type protocol.
protocol Food {}

// (2)
// Make Fruit conform Food protocol.
class Fruit: Food {
    var name: String
    var price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}

// (2)
// Make Meat conform Food protocol.
struct Meat: Food {
    var name: String
    var price: Double
}

let item1 = Fruit(name: "apple", price: 2.4)
let item2 = Meat(name: "beef", price: 10.9)

// (3)
// Create a new single array(basket) and make it conform Food protocol.
let basket: [Food] = [item1, item2]

/*
 Protocol is a first-class-citizen and its type can be used as
 - parameter and return types in functions, methods, and initializers.
 - the type for constants, variables, and properties.
 - the type for items in containers such as arrays and dictionaries.

 To check if a type adopts a protocol, we use type-casting operators: is, as, as?, and as!.
 - is returns a Boolean value indicating whether a type adopts a protocol.
 - as attempts a compile-time cast to a protocol type. It is commonly used for upcasting, similar to casting to a superclass. However, it cannot be used for casting from a protocol to a class.
 - as? attempts a cast to a protocol type and returns an optional value of the protocol type if successful. If the cast fails, it returns nil.
 - as! operator is similar to as?, but it forcefully unwraps the protocol type if successful. If the cast fails, it results in a runtime error.
 */

protocol FoodUpdated {
    // (1)
    // Define a new function in Food protocol.
    func slice()
}

class FruitUpdated: FoodUpdated {
    var name: String
    var price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    // (2)
    // slice() should be added because Fruit and Animal conform Food protocol.
    func slice() {
        print("This fruit can be sliced.")
    }
    
    // (3)
    // vegetarian() is independent with Food protocol.
    func vegetarian() {
        print("vegetarians eat fruit.")
    }
}

struct MeatUpdated: FoodUpdated {
    var name: String
    var price: Double
    
    // (2)
    // slice() should be added because Fruit and Animal conform Food protocol.
    func slice() {
        print("This meat can be sliced.")
    }
    
    // (3)
    // vegetarian() is independent with Food protocol.
    func vegetarian() {
        print("vegetarians don't eat meat.")
    }
}

// (4)
// The types of item1 and item2 areFruit and Meat, respectively.
// Note that the types of item3 and item4 are both Food.
let item11: FruitUpdated = FruitUpdated(name: "apple", price: 2.4)
let item21: MeatUpdated = MeatUpdated(name: "chicken", price: 10.9)
let item31: FoodUpdated = FruitUpdated(name: "banana", price: 1.9)
let item41: FoodUpdated = MeatUpdated(name: "pork", price: 7.2)

let basket1: [FoodUpdated] = [item11, item21, item31, item41]

// (5)
// All items can call function slice() as they all conform Food protocol.
item11.slice()
item21.slice()
item31.slice()
item41.slice()

// (6)
// However, when items want to call function vegetarian(),
// item31 and item41 should be downcasted(as! or as?) as FruitUpdated and MeatUpdated
// as they are FoodUpdated protocol type variables which is like a super-class type of FruitUpdated or MeatUpdated.
item11.vegetarian()
item21.vegetarian()
(item31 as! FruitUpdated).vegetarian()
(item41 as! MeatUpdated).vegetarian()
