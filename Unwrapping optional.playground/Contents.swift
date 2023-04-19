import UIKit


var string1: String //normal var
var string2: String! // implicitly wnwrapped optional
var string3: String? // optional

//print(string1) // error : Variable 'string1' used before being initialized . so no memory allocated
print(string2) // warning: Coercion of implicitly unwrappable value of type 'String?' to 'Any' does not unwrap optional only. memory allocated
print(string3) // warning :Expression implicitly coerced from 'String?' to 'Any'.  memory allocated


//withUnsafePointer(to: &string1) { str1 in
//    print("String1 address is \(str1)")
//} // error : Variable 'string1' passed by reference before being initialized

withUnsafePointer(to: &string2) { str2 in
    print("String1 address is \(str2)")
}

withUnsafePointer(to: &string3) { str3 in
    print("String1 address is \(str3)")
}


//string1 = string3 // error : Value of optional type 'String?' must be unwrapped to a value of type 'String'

//solution:
if let value = string3 {
    string1 = value
}


//string1 = string2 // no error , but crash on running


string2 = "Test"
string3 = "qwerty"

string1 = string2
print(string1) // prints : Test
print(string2) // prints : Optional("Test")

// Compiler does the optional binding when we assign string2 to string1


//string1 = string3 // error : Value of optional type 'String?' must be unwrapped to a value of type 'String'

if let value = string3 {
    string1 = value
}
print(string1) // prints : qwerty
print(string3) // prints : Optional("qwerty")


print(string2.lowercased())
//print(string3.lowercased()) // error : Value of optional type 'String?' must be unwrapped to refer to member 'lowercased' of wrapped base type 'String'

print(string3?.lowercased()) // warning : Expression implicitly coerced from 'String?' to 'Any'

print(string3?.lowercased() as Any) // no warning.
