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
}
