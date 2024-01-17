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

// In the above example, we define a protocol Container with an associated type Item. The Container protocol provides a blueprint for a generic container type. We then implement the Stack structure, which conforms to the Container protocol by associating its generic type T with the associated type Item. This allows us to create a stack of any type and fulfil the requirements of the Container protocol.

/*
 Generic Where Clauses:

 Generic where clauses allow us to add additional constraints to type parameters in generic functions and extensions. They provide more fine-grained control over type constraints, enabling us to express complex requirements.
 */

func allItemsMatch<C1: Container, C2: Container>(_ container1: C1, _ container2: C2) -> Bool
where C1.Item == C2.Item, C1.Item: Equatable {
    return container1.count == container2.count
}

/*
 This function takes two containers and checks if all the items in the containers match each other. Let’s break down the generic where clauses used in this function:

     C1: Container, C2: Container: This part of the clause specifies that C1 and C2 must be types that conform to the Container protocol. It ensures that the function can only be called with containers that have the required capabilities (append(_:), count, and subscript) defined in the Container protocol.
     C1.Item == C2.Item: This clause states that the associated type Item of C1 must be the same as the associated type Item of C2. It ensures that both containers contain items of the same type.
     C1.Item: Equatable: This clause specifies that the associated type Item of C1 must conform to the Equatable protocol. It allows the function to compare the items for equality using the == operator.

 With these generic where clauses, the function allItemsMatch(_:_:) can only be called with two containers (C1 and C2) that conform to the Container protocol, have the same associated type for Item, and have items that are Equatable. This provides compile-time safety and ensures that the function can only operate on compatible containers.
 */
