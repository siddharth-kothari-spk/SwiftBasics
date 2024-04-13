struct Stack<Element> {
  private var items: [Element] = []

  mutating func push(_ item: Element) {
    items.append(item)
  }

  mutating func pop() -> Element? {
    return items.isEmpty ? nil : items.removeLast()
  }

  func peek() -> Element? {
    return items.last
  }

  var isEmpty: Bool {
    return items.isEmpty
  }
}

struct Queue<Element> {
  private var inStack = Stack<Element>()
  private var outStack = Stack<Element>()

  mutating func enqueue(_ item: Element) {
    inStack.push(item)
  }

  mutating func fillOutStack() {
    if outStack.isEmpty {
      while let element = inStack.pop() {
        outStack.push(element)
      }
    }
  }

   mutating func dequeue() -> Element? {
    fillOutStack()
    return outStack.pop()
  }

  mutating func peek() -> Element? {
    fillOutStack()
    return outStack.peek()
  }

  var isEmpty: Bool {
    return inStack.isEmpty && outStack.isEmpty
  }
}

// Sample Usage
var queue = Queue<Int>()
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)

print("Peek:", queue.peek()!) // Output: Peek: 1
print("Dequeued Element:", queue.dequeue()!)  // Output: Dequeued Element: 1
print("Dequeued Element:", queue.dequeue()!)  // Output: Dequeued Element: 2

