import Foundation

public class Node<Value> {
  public var value: Value
  public weak var next: Node<Value>?

  public init(value: Value) {
    self.value = value
  }
}

extension Node: CustomStringConvertible {
    public var description: String {
    return "\(value)"
  }
}


public class LinkedList<Value> {
  private var head: Node<Value>?
  private var tail: Node<Value>?

  public var isEmpty: Bool {
    return head == nil
  }

  public func append(_ value: Value) {
    let newNode = Node(value: value)
      print("newNode: \(newNode)")
    if tail == nil {
      head = newNode
        tail = head
        print("tail is nil , now head points to \(newNode)")
    } else {
      tail!.next = newNode
        tail = newNode
        print("tail is not nil, now head ponts to \(head), tail points to \(newNode)")
    }
   // tail = newNode
      print("tail : \(tail)")
  }

  public func getNode(at index: Int) -> Node<Value>? {
    if isEmpty {
        print("empty")
      return nil
    }

    var currentNode = head
    var currentIndex = 0
      print(currentNode, currentIndex)
    while currentNode != nil && currentIndex < index {
      currentNode = currentNode?.next
      currentIndex += 1
        print(currentNode, currentIndex)
    }
    return currentNode
  }

  public func removeNode(at index: Int) -> Node<Value>? {
    if isEmpty {
      return nil
    }

    if index == 0 {
      let removedNode = head
      head = head?.next
      if head == nil {
        tail = nil
      }
      return removedNode
    }

    guard let previousNode = getNode(at: index - 1) else {
      return nil
    }

    let removedNode = previousNode.next
    previousNode.next = removedNode?.next
    if previousNode.next == nil {
      tail = previousNode
    }
    return removedNode
  }
    
    public func description() -> String {
        if isEmpty {
            return "no elements in linked list"
        }
        
        var node = head
        var output = ""
        
        while node != nil {
            output += node!.description + "->"
        }
        output += "nil"
        
        return output
    }
}

// Example usage
var list = LinkedList<String>()
list.append("Apple")
list.append("Banana")
list.append("Cherry")

//print(list.description())

//if let node = list.getNode(at: 1) {
//  print(node.description) // Output: Banana
//}

let node = list.getNode(at: 1)
print(node?.description)

list.removeNode(at: 1)

if let node = list.getNode(at: 1) {
  print(node.description) // Output: Cherry (Banana removed)
}

/*
This code defines two classes:

* `Node`: This class represents a single node in the linked list. It has two properties:
    * `value`: The data stored in the node.
    * `next`: A weak reference to the next node in the list.
* `LinkedList`: This class manages the linked list. It has properties for the head and tail nodes, as well as methods for adding, removing, and accessing nodes.

The code also includes some example usage that demonstrates how to create a linked list, add elements, access nodes by index, and remove nodes.
*/
