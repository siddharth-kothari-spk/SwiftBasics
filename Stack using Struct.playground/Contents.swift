import UIKit

struct Stack<Element> {
    private var elements: [Element] = []
    
    mutating func push(_ element: Element) {
        elements.append(element)
    }
    
    mutating func pop() -> Element? {
        return elements.popLast()
    }
    
    func peek() -> Element? {
        return elements.last
    }
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    func count() -> Int {
        return elements.count
    }
}
/*
 In this example, we define a generic struct called Stack that can hold elements of any type. The stack is implemented using an array as the underlying data structure.

 The push method is used to add an element to the top of the stack by appending it to the elements array.

 The pop method removes and returns the topmost element from the stack by using the popLast function on the elements array.

 The peek method returns the topmost element of the stack without removing it. It uses the last property on the elements array.

 The isEmpty method checks if the stack is empty by calling the isEmpty function on the elements array.

 The count method returns the number of elements currently in the stack by accessing the count property of the elements array.
 */

var stack = Stack<Int>()

stack.push(1)
stack.push(2)
stack.push(3)

print(stack.peek())  // Output: Optional(3)
print(stack.pop())   // Output: Optional(3)
print(stack.count()) // Output: 2
print(stack.isEmpty()) // Output: false

/*
 In Swift, the mutating keyword is used to indicate that a method is allowed to modify (mutate) the properties of a value type (such as a struct) within its implementation.

 In the context of the push and pop methods in the Stack struct, the mutating keyword is used because these methods modify the elements property of the struct. Since Stack is a value type (struct), its properties are immutable by default. However, when you want to modify the properties of a struct within a method, you need to mark that method as mutating.

 Here's a breakdown of the usage of the mutating keyword in the push and pop methods:

     mutating func push(_ element: Element): This method is marked as mutating because it modifies the elements array by appending an element to it.

     mutating func pop() -> Element?: Similarly, this method is marked as mutating because it modifies the elements array by removing and returning the last element.

 By using the mutating keyword, you're explicitly indicating that these methods are allowed to modify the state of the struct. Without the mutating keyword, you wouldn't be able to modify properties within the method implementation of a value type in Swift.
 */
