//courtsey: https://levelup.gitconnected.com/practical-examples-of-swift-extensions-2d13deb4b7c8

import UIKit
import Foundation


/*
 1. Adding Computed Properties

 Swift extensions are an excellent way to add computed properties to existing types. Computed properties allow you to calculate values based on the existing properties of a type or even introduce entirely new properties.
 */

extension String {
    var length: Int {
        return count
    }
}

let text = "Hello, Swift"
let textLength = text.length // 12

/*
 2. Implementing Protocol Conformance

 Extensions can be used to make existing types conform to protocols. This is especially useful when you want to adapt types to specific requirements or when working with libraries that expect conforming types.
 */

extension Int: CustomStringConvertible {
    public var description: String {
        return "Number: \(self)"
    }
}

let number = 42
print(number) // Number: 42
