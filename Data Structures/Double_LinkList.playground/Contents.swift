public class Node<Value> {
  public var value: Value
  public weak var previous: Node<Value>?
  public var next: Node<Value>?

  public init(value: Value) {
    self.value = value
  }
}

public class DoublyLinkedList<Value> {
  private var head: Node<Value>?
  private var tail: Node<Value>?

  public var isEmpty: Bool {
    return head == nil
  }

  public func append(_ value: Value) {
    let newNode = Node(value: value)
    if tail == nil {
      head = newNode
    } else {
      tail!.next = newNode
      newNode.previous = tail
    }
    tail = newNode
  }

  public func prepend(_ value: Value) {
    let newNode = Node(value: value)
    if head == nil {
      head = newNode
      tail = newNode
    } else {
      head!.previous = newNode
      newNode.next = head
      head = newNode
    }
  }

  public func insert(at index: Int, value: Value) {
    if index == 0 {
      prepend(value)
      return
    }

    guard let node = getNode(at: index) else {
      append(value)
      return
    }

    let newNode = Node(value: value)
    if node === head {
      head!.next = newNode
      newNode.previous = head
      head = newNode
    } else if node === tail {
      node.previous!.next = newNode
      newNode.previous = node.previous
      newNode.next = node
      tail = newNode
    } else {
      node.previous!.next = newNode
      newNode.previous = node.previous
      newNode.next = node
      node.previous = newNode
    }
  }

  public func getNode(at index: Int) -> Node<Value>? {
    if isEmpty {
      return nil
    }

    var currentNode = head
    var currentIndex = 0
    while currentNode != nil && currentIndex < index {
      currentNode = currentNode?.next
      currentIndex += 1
    }
    return currentNode
  }

  public func remove(at index: Int) -> Node<Value>? {
    if isEmpty {
      return nil
    }

    if index == 0 {
      let removedNode = head
      head = head?.next
      if head != nil {
        head!.previous = nil
      } else {
        tail = nil
      }
      return removedNode
    }

    guard let previousNode = getNode(at: index - 1) else {
      return nil
    }

    let removedNode = previousNode.next
    if removedNode === tail {
      tail = previousNode
    } else {
      removedNode?.next?.previous = previousNode
    }
    previousNode.next = removedNode?.next
    return removedNode
  }
}

// Example usage
var list = DoublyLinkedList<String>()
list.append("Apple")
list.append("Banana")
list.prepend("Cherry")

if let node = list.getNode(at: 1) {
  print(node.value) // Output: Banana
}

list.insert(at: 1, value: "Orange")

if let node = list.getNode(at: 1) {
  print(node.value) // Output: Orange
}

list.remove(at: 2)

if let node = list.getNode(at: 1) {
  print(node.value) // Output: Banana (Orange removed)
}
