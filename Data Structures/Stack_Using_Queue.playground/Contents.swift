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
    return items.first
  }

  var isEmpty: Bool {
    return items.isEmpty
  }
    
    func itemsDescription() {
        print(items)
    }
}

struct Stack<Element> {
  private var q1 = Queue<Element>()
  private var q2 = Queue<Element>() // This will be the "active" queue

  mutating func push(_ item: Element) {
      print("Before push-------")
      print("q1: \(q1.itemsDescription())")
      print("q2: \(q2.itemsDescription())")
    if !q2.isEmpty { // Move elements to q1 if q2 is not empty
      while let element = q2.dequeue() {
        q1.enqueue(element)
      }
    }
    q2.enqueue(item) // Enqueue new element to the active queue
      print("After push-------")
      print("q1: \(q1.itemsDescription())")
      print("q2: \(q2.itemsDescription())")
  }

    mutating func pop() -> Element? {
        print("Before pop-------")
        print("q1: \(q1.itemsDescription())")
        print("q2: \(q2.itemsDescription())")
    if q2.isEmpty { // Move elements to q2 if q2 is empty
      while let element = q1.dequeue() {
        q2.enqueue(element)
      }
    }
        print("After pop-------")
        print("q1: \(q1.itemsDescription())")
        print("q2: \(q2.itemsDescription())")
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
var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)

print("****************")
print("Popped Element:", stack.pop()!)  // Output: Popped Element: 3
print("****************")
print("Popped Element:", stack.pop()!)
print("****************")
print("Peek Element:", stack.peek()!)  // Output: Peek Element: 2

