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

/*
 3. Providing Convenience Initializers

 Extensions allow you to add convenience initializers to types. This is valuable when you need to create instances with specific configurations without cluttering the primary initializer.
 */
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
}

let customColor = UIColor(red: 100, green: 200, blue: 50)

/*
 4. Adding Methods

 Extensions can add methods to types, providing new functionality that wasn’t originally part of the type’s definition.
 */

extension Array where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
}

let numbers = [1, 2, 3, 4, 5]
let total = numbers.sum() // 15

/*
 5. Adding Subscripts

 Extensions can add subscripts to types, providing indexed access to elements. Subscripts are a valuable way to offer more convenient access to specific elements within a type.
 */
extension String {
    subscript(index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
}

let text2 = "Swift"
let thirdCharacter = text2[2] // "i"

