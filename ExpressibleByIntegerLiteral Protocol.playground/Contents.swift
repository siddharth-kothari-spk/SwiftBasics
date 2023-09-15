// https://medium.com/cleansoftware/what-is-the-expressiblebyintegerliteral-protocol-in-swift-e71ad4a37a96

import Foundation

struct CustomNumber {
    let value: Int?
    let isEven: Bool? = false
}

// we can initialize customNUmber by
let customNumbers: [CustomNumber] =
    [
        .init(value: 4),
        .init(value: 24),
        .init(value: 65),
        .init(value: 44)
    ]

print(customNumbers)

struct CustomNumberExpressible {
    let value: Int?
    let isEven: Bool?
}

// expressible as Int
extension CustomNumberExpressible: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.value = value
        self.isEven = self.value?.isMultiple(of: 2)
    }
}
print("\n")

let customNumbersExpressibleByIntegerLiteral : [CustomNumberExpressible] = [1, 4, 5 ,6 , 9]

print(customNumbersExpressibleByIntegerLiteral)


// conforming to String

extension CustomNumberExpressible: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.value = Int(value)
        self.isEven = self.value?.isMultiple(of: 2)
    }
}

print("\n")
let customNumbersExpressibleByStringLiteral: [CustomNumberExpressible] = ["1", "2", "3"]
print(customNumbersExpressibleByStringLiteral)
