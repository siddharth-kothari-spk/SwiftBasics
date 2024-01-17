// courtsey: https://medium.com/@w.raviraj/mastering-generics-in-swift-advanced-concepts-and-examples-85d5cfe11dca

import UIKit

// Generics in Swift offer developers a powerful toolset for writing flexible and reusable code.

/*
 Associated Types:

 Associated types allow us to define generic protocols that can work with different types in a flexible manner. By associating a type with a protocol, we can leave the actual type implementation to conforming types. Let’s dive into an example.
 */

protocol Container {
    associatedtype Item
    var count: Int { get }
    mutating func append(_ item: Item)
    subscript(i: Int) -> Item { get }
}

struct Stack<T>: Container {
    
    var items = [T]()
    mutating func push(_ item: Item) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    typealias Item = T
    
    var count: Int {
        return items.count
    }
    
    mutating func append(_ item: T) {
        push(item)
    }
    
    subscript(i: Int) -> T {
        return items[i]
    }
}

var stack = Stack<Int>()
stack.append(1)
stack.append(2)
stack.append(3)
print(stack[0]) // Output: 1
print(stack.count) // Output: 3
