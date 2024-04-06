public class TreeNode<Value: Comparable>{
    public static func == (lhs: TreeNode<Value>, rhs: TreeNode<Value>) -> Bool {
        lhs.value == rhs.value
    }
    
  public var value: Value
  public var parent: TreeNode<Value>?
  public var leftChild: TreeNode<Value>?
  public var rightChild: TreeNode<Value>?

  public init(value: Value) {
    self.value = value
  }

  public func isLeaf() -> Bool {
    return leftChild == nil && rightChild == nil
  }
}

public func ==<T: Equatable>(lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
    lhs.value == rhs.value
}

public func <<T: Comparable>(lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
    lhs.value < rhs.value
}

public class BinaryTree<Value: Comparable> {
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
    
    public func preOrderTraversal(visit: (Value) -> Void) {
        preOrderTraversal(node: root, visit: visit)
    }

    private func preOrderTraversal(node: TreeNode<Value>?, visit: (Value) -> Void) {
      guard let node = node else { return }
        visit(node.value)
        preOrderTraversal(node: node.leftChild, visit: visit)
        preOrderTraversal(node: node.rightChild, visit: visit)
    }
    
    public func postOrderTraversal(visit: (Value) -> Void) {
        postOrderTraversal(node: root, visit: visit)
    }

    private func postOrderTraversal(node: TreeNode<Value>?, visit: (Value) -> Void) {
      guard let node = node else { return }
        postOrderTraversal(node: node.leftChild, visit: visit)
        postOrderTraversal(node: node.rightChild, visit: visit)
        visit(node.value)
    }
}

var tree = BinaryTree<Int>()
tree.root = TreeNode(value: 100)

tree.add(50)
tree.add(150)
tree.add(75)
tree.add(130)
tree.add(111)
tree.add(125)
tree.add(175)
tree.add(85)
//             100
//   50                   150
// X    75           130         175
//    X    85    111      125
print(tree.root?.value as Any)

print("Inorder")
tree.inOrderTraversal { value in
    print(value, separator: "->")
}

print("PreOrder")
tree.preOrderTraversal { value in
    print(value, separator: "->")
}

print("PostOrder")
tree.postOrderTraversal { value in
    print(value, separator: "->")
}

/*
 Output:
 
 Inorder
 50
 75
 85
 100
 111
 125
 130
 150
 175
 
 PreOrder
 100
 50
 75
 85
 150
 130
 111
 125
 175
 
 PostOrder
 85
 75
 50
 125
 111
 130
 175
 150
 100
 */
