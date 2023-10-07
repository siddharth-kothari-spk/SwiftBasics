// https://medium.com/geekculture/understanding-the-mutating-keyword-in-swift-71163418e2f6

import Foundation

struct StructSample {
    var firstProperty: String
    
    // Our apps logic requires us to ensure each user has a capitalized firstProperty
    
    // error: Cannot assign to property: 'self' is immutable
    
   /*
    A Struct’s properties are immutable from within the Struct itself, in other words Swift cannot infer if the Struct will be declared as a variable or a constant when created, so be safe Swift does not allow any changes to a Struct’s properties from within its methods.
    
    func modifyFirstProperty() {
        firstProperty = firstProperty.capitalized
    }
    */
    
    // The mutating keyword flags our function with the ability to work with our properties as variables
    mutating func modifyFirstPropertyMutating() {
        firstProperty = firstProperty.capitalized
    }
    
    /*
     It’s important to know that our Struct’s properties are still immutable, so why does the Mutating keyword allow us to manipulate our properties? Under the hood Swift makes a new copy of our Struct and assigns our new values to its properties. The original Struct we defined is then replaced by our copied struct. Since Structs are value types, they are always copied when they are assigned to new variables or constants and do not contain a reference to a specific spot in memory.
     */
}

var firstStruct: StructSample = StructSample(firstProperty: "first property")
print(firstStruct.firstProperty)
firstStruct.modifyFirstPropertyMutating()
print(firstStruct.firstProperty)


let secondStruct: StructSample = StructSample(firstProperty: "second property")
print(secondStruct.firstProperty)
//secondStruct.modifyFirstPropertyMutating() // error: Cannot use mutating member on immutable value: 'secondStruct' is a 'let' constant
print(secondStruct.firstProperty)



struct StructSample2 {
    let firstProperty: String
    mutating func modifyFirstPropertyMutating() {
      //  firstProperty = firstProperty.capitalized
        // error: Cannot assign to property: 'firstProperty' is a 'let' constant
    }
}
