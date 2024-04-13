import Foundation

struct Queue<Element> {
  private var items: [Element] = []

  mutating func enqueue(_ item: Element) {
    items.append(item)
  }

  mutating func dequeue() -> Element? {
    guard !items.isEmpty else { return nil }
    let element = items.removeFirst()
    return element
  }

  func peek() -> Element? {
      return items.last
  }

  var isEmpty: Bool {
    return items.isEmpty
  }
    
    func itemsDescription() {
        print(items)
    }
    
    func count() -> Int {
        return items.count
    }
}

/*
struct Stack<Element> {
  private var q1 = Queue<Element>()
  private var q2 = Queue<Element>() // This will be the "active" queue

  mutating func push(_ item: Element) {
//      print("Before push-------")
//      print("q1: \(q1.itemsDescription())")
//      print("q2: \(q2.itemsDescription())")
    if !q2.isEmpty { // Move elements to q1 if q2 is not empty
      while let element = q2.dequeue() {
        q1.enqueue(element)
      }
    }
    q2.enqueue(item) // Enqueue new element to the active queue
//      print("After push-------")
//      print("q1: \(q1.itemsDescription())")
//      print("q2: \(q2.itemsDescription())")
  }

    mutating func pop() -> Element? {
//        print("Before pop-------")
//        print("q1: \(q1.itemsDescription())")
//        print("q2: \(q2.itemsDescription())")
    while q2.isEmpty { // Move elements to q2 if q2 is empty
      while let element = q1.dequeue() {
        q2.enqueue(element)
      }
    }
//        print("q1: \(q1.itemsDescription())")
//        print("q2: \(q2.itemsDescription())")
       // let val = q2.dequeue()
//        let temp = q1
//        q1 = q2
//        q2 = temp
//        print("q1: \(q1.itemsDescription())")
//        print("q2: \(q2.itemsDescription())")
//        print("After pop-------")
//        print("q1: \(q1.itemsDescription())")
//        print("q2: \(q2.itemsDescription())")
       // return val
    return q2.dequeue() // Dequeue from the active queue
  }

    mutating func peek() -> Element? {
    if q2.isEmpty { // Move elements to q2 if q2 is empty (same as pop)
      while let element = q1.dequeue() {
        q2.enqueue(element)
      }
    }
    return q2.peek() // Peek from the active queue
  }

  var isEmpty: Bool {
    return q1.isEmpty && q2.isEmpty
  }
}

// Sample Usage
var stack1 = Stack<Int>()
stack1.push(1)
stack1.push(2)
stack1.push(3)

print("****************")
print("Popped Element:", stack1.pop()!)  // Output: Popped Element: 3
print("****************")
print("Popped Element:", stack1.pop()!)
print("****************")
print("Peek Element:", stack1.peek()!)  // Output: Peek Element: 2

*/


struct Stack2<T> {
    private var queue1: Queue<T> = Queue<T>()
    private var queue2: Queue<T> = Queue<T>()

    // Adds an element to the top of the stack
    mutating func push(_ element: T) {
        // Always push to the first queue
        queue1.enqueue(element)
    }

    // Removes the top element of the stack and returns it
    mutating func pop() -> T? {
        // Move all elements except the last one from queue1 to queue2
        while queue1.count() > 1 {
            if let element = queue1.dequeue() {
                queue2.enqueue(element)
            }
        }
        
        // The last element in queue1 is the top of the stack
        let topElement = queue1.dequeue()
        
        // Swap the names of queue1 and queue2
        (queue1, queue2) = (queue2, queue1)
        
        return topElement
    }

    // Returns the top element of the stack without removing it
    func peek() -> T? {
        guard !queue1.isEmpty else { return nil }
        return queue1.peek()
    }

    // Returns whether the stack is empty
    func isEmpty() -> Bool {
        return queue1.isEmpty
    }
}

// Example Usage
var stack = Stack2<Int>()
stack.push(1)
stack.push(2)
stack.push(3)
print(stack.pop() ?? "Stack is empty")  // Output: 3
print(stack.peek() ?? "Stack is empty") // Output: 2
print(stack.pop() ?? "Stack is empty")  // Output: 2
print(stack.pop() ?? "Stack is empty")  // Output: 1
print(stack.isEmpty())                  // Output: true
