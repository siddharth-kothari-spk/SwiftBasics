
import Foundation

// Method 1
struct Stack<Element> {
  private var items: [Element] = []
  
  public mutating func push(_ element: Element) {
    items.append(element)
  }
  
  public mutating func pop() -> Element? {
    return items.popLast()
  }
  
  public func peek() -> Element? {
    return items.last
  }
  
  public var isEmpty: Bool {
    return items.isEmpty
  }
}

/*
This code defines a struct named `Stack` that can hold elements of any type. The `items` property is an internal array that stores the elements in the stack.

Here's a breakdown of the methods:

* `push(_ element:)`: This method adds a new element to the top of the stack.
* `pop()`: This method removes and returns the element at the top of the stack. It returns nil if the stack is empty.
* `peek()`: This method returns the element at the top of the stack without removing it. It returns nil if the stack is empty.
* `isEmpty`: This property is a boolean value that indicates whether the stack is empty.

This is a basic implementation of a stack. You can extend it further by adding functionalities like checking the size of the stack or implementing a maximum size limit.

*/


// Method 2

protocol Stackable {
  associatedtype Element
  
  mutating func push(_ element: Element)
  func peek() -> Element?
  mutating func pop() -> Element?
  var isEmpty: Bool { get }
}

extension Stackable {
  var isEmpty: Bool {
    return peek() == nil
  }
}

struct StackViaProtocol<Element>: Stackable where Element: Equatable {
  private var storage: [Element] = []
  
  mutating func push(_ element: Element) {
    storage.append(element)
  }
  
  func peek() -> Element? {
    return storage.last
  }
  
  mutating func pop() -> Element? {
    return storage.popLast()
  }
}

extension StackViaProtocol: Equatable {
  static func == (lhs: StackViaProtocol<Element>, rhs: StackViaProtocol<Element>) -> Bool {
    return lhs.storage == rhs.storage
  }
}

extension StackViaProtocol: CustomStringConvertible {
  var description: String {
    return "\(storage)"
  }
}

extension StackViaProtocol: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: Self.Element...) {
    storage = elements
  }
}
