
import Foundation

// Method 1
struct Queue<Element> {
  private var items: [Element] = []

  public mutating func enqueue(_ element: Element) {
    items.append(element)
  }

  public mutating func dequeue() -> Element? {
    return items.removeFirst()
  }

  public func peek() -> Element? {
    return items.first
  }

  public var isEmpty: Bool {
    return items.isEmpty
  }
}

var queue: Queue<(Int, String)> =  Queue<(Int, String)>()
print(queue.isEmpty)

queue.enqueue((100, "A"))
queue.enqueue((200, "C"))

print(queue.peek() as Any)

queue.dequeue()
print(queue.peek() as Any)

/*
This code defines a struct named `Queue` that can hold elements of any type. The `items` property is an internal array that stores the elements in the queue.

Here's what each method does:

* `enqueue(_ element:)`: This method adds a new element to the back of the queue.
* `dequeue()`: This method removes and returns the element at the front of the queue (First-In-First-Out order). It returns nil if the queue is empty.
* `peek()`: This method returns the element at the front of the queue without removing it. It returns nil if the queue is empty.
* `isEmpty`: This property is a boolean value that indicates whether the queue is empty.

**Important Note:**

While this implementation is simple, removing elements from the front of an array (`removeFirst`) has a time complexity of O(n) in the worst case. This means that as the queue size grows, removing elements can become slower.

For better performance, consider implementing a circular queue or using Swift's built-in `Deque` type, which is specifically designed for efficient queue operations.

*/

// Method 2

protocol Queueable {
    associatedtype Element
    
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
    func peek() -> Element?
    func count() -> Int
    var isEmpty: Bool { get }
}

extension Queueable {
    var isEmpty: Bool {
        return peek() == nil
    }
}

struct QueueViaProtocol<Element>: Queueable where Element: Equatable {
    
    private var storage: [Element] = []
    
    mutating func enqueue(_ element: Element) {
      storage.append(element)
    }
    
    mutating func dequeue() -> Element? {
        storage.removeFirst()
    }
    
    func peek() -> Element? {
        storage.first
    }
    
    func count() -> Int {
        storage.count
    }
}

var queueViaProtocol: QueueViaProtocol<String> = QueueViaProtocol<String>()
print(queueViaProtocol.count())

queueViaProtocol.enqueue("ASD")
queueViaProtocol.enqueue("DEF")
print(queueViaProtocol.count())

print(queueViaProtocol.peek() as Any)
print(queueViaProtocol.count())

queueViaProtocol.dequeue()
print(queueViaProtocol.peek() as Any)
print(queueViaProtocol.count())
