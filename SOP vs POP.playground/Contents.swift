// courtsey: https://itnext.io/structure-oriented-programming-vs-protocol-oriented-programming-in-swift-023970d80c75

import UIKit

/*
 how to write code according to the SOLID principles without using protocols and without losing abstraction.

 The Structure Oriented Programming is a paradigm based on the fact that any protocol can be replaced by a structure.

 The advantages of this approach is performance.
 Since the structure-oriented approach is based on structures that use static dispatch, the dispatch speed will be significantly different from protocols with dynamic dispatch in the protocol-oriented approach.
 */

/*
 1. Replacing a protocol with an equivalent structure

 In a protocol-oriented approach, the protocol itself allows abstraction from the implementation.

 In the structure-oriented approach, generics and closures help to provide abstraction.
 */


// Abstraction
protocol RegularProtocol {
    var sqrValue: Int { get }
}

// Object
class RegularClassProtocol {
    
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
}

// Realization
extension RegularClassProtocol: RegularProtocol {
    var sqrValue: Int {
        value * value
    }
}

let onbjectProtocol = RegularClassProtocol(value: 25)
print(onbjectProtocol.sqrValue)


// Abstraction
struct RegularStruct<AdoptedObject> {
    var sqrValue: (AdoptedObject) -> Int
    
    init(sqrValue: @escaping (AdoptedObject) -> Int) {
        self.sqrValue = sqrValue
    }
}

// Object
class RegularClassStruct {
    
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
}

// Realization
extension RegularStruct where AdoptedObject == RegularClassStruct {
    init() {
        sqrValue = { object in object.value * object.value }
    }
}

let onbjectStruct = RegularStruct<RegularClassStruct>()
print(onbjectStruct.sqrValue(.init(value: 25)))


/*
 2. Covering all kinds of cases

 To understand how to use structure-oriented approach in practice, let’s consider the most likely cases of using the protocol:

     Computed property
     Property with getter and setter
     Static property
     Regular method
     Static function
     Function with associated value
     Parent protocol function when inheriting protocols
 */

protocol ProtocolExample: ParentProtocolExample {
    // 1
    var getVariable: Int { get }
    
    // 2
    var getSetVariable: Int { get set }
    
    // 3
    static var staticVariable: Int { get }
    
    // 4
    func regularFunction(value: Int) -> Bool
    
    // 5
    static func staticFunction(value: Int) -> Bool
    
    // 6
    associatedtype Value
    func assosiatedFunction(value: Value) -> Bool
}

protocol ParentProtocolExample {
    // 7
    func inheritedFunction() -> String
}





struct StructExample<AdoptedObject, Value> {
    // 1
    var getVariable: (_ object: AdoptedObject) -> Int
    
    // 2
    var setVariable: (_ object: AdoptedObject, Int) -> Void
    
    // 3
    var staticVariable: () -> Int
    
    // 4
    var regularFunction: (_ object: AdoptedObject, _ value: Int) -> Bool
    
    // 5
    var staticFunction: (_ value: Int) -> Bool
    
    // 6
    var assosiatedFunction: (_ object: AdoptedObject, _ value: Value) -> Bool
    
    // 7
    var parentStruct: ParentStructExample<AdoptedObject>
    var inheritedFunction: () -> String
}

struct ParentStructExample<AdoptedObject> {
    var inheritedFunction: () -> String
}
