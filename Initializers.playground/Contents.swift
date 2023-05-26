import UIKit

class PersonClass {
    var name: String
    var country: String
    
    // Designated initializer 1
    init(name:String, country:String) {
        self.name = name
        self.country = country
    }
    
    // Designated initializer 2
    init(name:String) {
        self.name = name
        self.country = "Default"
    }
    
    // Convenience init - it is ssecondary , needs designated initializer
    convenience init(country:String) {
        self.init(name: "Name", country: country)
    }
}

// struct have default initializers
struct PersonStruct {
    var name: String
    var country: String
}


let classPerson1 = PersonClass(name: "Test")
print(classPerson1.country)

let classPerson2 = PersonClass(name: "Test2", country: "Default2")
print(classPerson2.country)

let structPerson = PersonStruct(name: "Test3", country: "Default3")
print(structPerson)


let classPerson3 = PersonClass(country: "Country")
print(classPerson3.name)



class PersonClassFailable {
    var name: String
    var country: String
    
    // Designated initializer 1
    init?(name:String, country:String) {
        if name.isEmpty {
            print("Empty name returning nil")
            return nil
        }
        self.name = name
        self.country = country
    }
    
    // Convenience init - as designated one is failable so convenience also needs to be failable
    convenience init?(country:String) {
        self.init(name: "Name", country: country)
    }
}


let failablePerson = PersonClassFailable(name: "", country: "")
print(failablePerson as Any)
