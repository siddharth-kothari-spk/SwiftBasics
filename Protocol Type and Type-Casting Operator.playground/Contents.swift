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

