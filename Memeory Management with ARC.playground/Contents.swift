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
