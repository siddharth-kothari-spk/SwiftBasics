import Combine

// dropFirst(_:)
// Omits the specified number of elements before republishing subsequent elements.

let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let cancellable1 = numbers.publisher
    .dropFirst(5)
    .sink { print("\($0)", terminator: " ") }

// // Prints: "6 7 8 9 10 "

print("\n")
// drop(untilOutputFrom:)
// Ignores elements from the upstream publisher until it receives an element from a second publisher.

let firstPublisher = PassthroughSubject<Int, Never>()
let secondPublisher = PassthroughSubject<String, Never>()

let cancellable2 = firstPublisher
    .drop(untilOutputFrom: secondPublisher).sink { print("\($0)", terminator: " ") }

firstPublisher.send(1)
firstPublisher.send(2)
secondPublisher.send("A")
firstPublisher.send(3)
firstPublisher.send(4)
// Prints "3 4"


print("\n")

// drop(while:)
// Omits elements from the upstream publisher until a given closure returns false, before republishing all remaining elements.

let numbers2 = [-62, -1, 0, 10, 0, 22, 41, -1, 5]
let cancellable3 = numbers2.publisher
    .drop { $0 < 0 }
    .sink { print("\($0)") }

// Prints: "0 10 0 22 41 -1 5"
print("\n")

// tryDrop(while:)
// Omits elements from the upstream publisher until an error-throwing closure returns false, before republishing all remaining elements.

enum RangeError: Error {
    case rangeError
}

var numbers3 = [1, 2, 3, 4, 5, 6, -1, 7, 8, 9, 10]
let range: CountableClosedRange<Int> = (1...100)
_ = numbers3.publisher
    .tryDrop {
        guard $0 != 0 else { throw RangeError.rangeError }
        return range.contains($0)
    }
    .sink(
        receiveCompletion: { print ("completion: \($0)") },
        receiveValue: { print ("value: \($0)") }
    )


// elements are ignored until -1 is encountered in the stream and the closure returns false. The publisher then republishes the remaining elements and finishes normally


// case for rangeError

var numbers4 = [1, 2, 3, 4, 0, 5, 6, -1, 7, 8, 9, 10]
_ = numbers4.publisher
    .tryDrop {
        guard $0 != 0 else { throw RangeError.rangeError }
        return range.contains($0)
    }
    .sink(
        receiveCompletion: { print ("completion: \($0)") },
        receiveValue: { print ("value: \($0)") }
    )
