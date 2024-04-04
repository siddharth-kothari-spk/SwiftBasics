public class TreeNode<Value> {
  public var value: Value
  public weak var parent: TreeNode<Value>?
  public var leftChild: TreeNode<Value>?
  public var rightChild: TreeNode<Value>?

  public init(value: Value) {
    self.value = value
  }

  public func isLeaf() -> Bool {
    return leftChild == nil && rightChild == nil
  }
}

public class BinaryTree<Value> {
  public var root: TreeNode<Value>?

  public func isEmpty() -> Bool {
    return root == nil
  }

  public func add(_ value: Value) {
    var currentNode = root

    if currentNode == nil {
      root = TreeNode(value: value)
      return
    }

    while true {
      if value < currentNode!.value {
        if currentNode!.leftChild == nil {
          currentNode!.leftChild = TreeNode(value: value)
          currentNode!.leftChild!.parent = currentNode
          break
        } else {
          currentNode = currentNode!.leftChild!
        }
      } else {
        if currentNode!.rightChild == nil {
          currentNode!.rightChild = TreeNode(value: value)
          currentNode!.rightChild!.parent = currentNode
          break
        } else {
          currentNode = currentNode!.rightChild!
        }
      }
    }
  }

  // Traversal methods (In-order, Pre-order, Post-order) can be implemented here

  public func inOrderTraversal(visit: (Value) -> Void) {
    inOrderTraversal(node: root, visit: visit)
  }

  private func inOrderTraversal(node: TreeNode<Value>?, visit: (Value) -> Void) {
    guard let node = node else { return }
    inOrderTraversal(node: node.leftChild, visit: visit)
    visit(node.value)
    inOrderTraversal(node: node.rightChild, visit: visit)
  }
}

