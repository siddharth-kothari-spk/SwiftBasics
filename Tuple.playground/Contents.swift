import UIKit

// Tuple
// 1. Named tuple

// create named tuple
var company = (product: "Programiz App", version: 2.1)

// access tuple element using name
print("tuple: ", company)
print("Product:", company.product)
print("Version:", company.version)
print("----------------------------")


// 2. Nested tuple

var alphabets = ("A", "B", "C", ("a", "b", "c"))

// access first element
print(alphabets.0)   // prints "A"

// access the third element
print(alphabets.3)

// access nested tuple
print(alphabets.3.0)  // prints "a"

print("----------------------------")

// 3. Cant remove or add to tuple , we can modify element though

var company2 = ("Programiz","Apple")

//company2.2 = "Google" // Error : Value of tuple type '(String, String)' has no member '2'

//company2.remove("Apple") // Error : Value of tuple type '(String, String)' has no member 'remove'

print(company2)
company2.0 = "Mac"
print(company2)
print("----------------------------")


// Dictionary Inside a Tuple

//In Swift, we can use a dictionary to add an element to a tuple.


var laptopLaunch = ("MacBook", 1299, ["Nepal": "10 PM", "England": "10 AM"])
print(laptopLaunch.2)

laptopLaunch.2["USA"] = "11 AM"

print(laptopLaunch.2)
 
 // the type of tuple is (String, String, Dictionary) , so we are able to modify tuple

laptopLaunch.2.removeValue(forKey: "Nepal")
print(laptopLaunch.2)
 
laptopLaunch.1 = 1099
print(laptopLaunch)
print("----------------------------")
