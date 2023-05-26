import UIKit

class Person: NSObject { // need to make it subclass of NSObject to have access to value(forKey:) method
   @objc dynamic var name: String
    
    init(name: String) {
        self.name = name
    }
}


// KVC
var person = Person(name: "test")
print("direct access : \(person.name)")

/*
let name  = person.value(forKey: "name") // error : The process has been left at the point where it was interrupted, use "thread return -x" to return to the state before expression evaluation.
// for this we made name as @objc and dynamic as KVC is Obj-C level api so we used @objc to comply for that .
// dynamic is used to make use of swift 'dynamic dispatch' . (enables KVO for the property)
 
 print("KVC access : \(String(describing: name))")
*/

if let name = person.value(forKey: "name") as? String {
    print("KVC access : \(String(describing: name))")
}


// KVO

let obj = person.observe(\.name, options: [.new, .old]) { person, value in
    print("KVO old : \(String(describing: value.oldValue))")
    print("KVO new : \(String(describing: value.newValue))")

}
person.name = "person"
// prints
// KVO old : Optional("test")
// KVO new : Optional("person")


