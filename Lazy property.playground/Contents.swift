import Foundation
/*class MyClass {
    lazy var lazyProperty: Int = {
        print("Initializing lazy property")
        return 42
    }()
}

let myObject = MyClass()

DispatchQueue.concurrentPerform(iterations: 10) { _ in
    print(myObject.lazyProperty)
}
*/

// Recursive enum
indirect enum Tree<T> {
    case leaf
    case node(value: T, left: Tree, right: Tree)
}

indirect enum LinkedList<T> {
    case empty
    case node(value: T, next: LinkedList)
}

let list = LinkedList.node(value: 1, next: .node(value: 2, next: .empty))
print(list)

indirect enum Expression {
    case value(Int)
    case addition(Expression, Expression)
    case multiplication(Expression, Expression)
}

let expression = Expression.addition(.value(2), .multiplication(.value(3), .value(4)))
print(expression)

