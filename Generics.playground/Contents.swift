import UIKit

struct IntStack {
    var items: [Int] = []

    mutating func push(_ item: Int) {
        items.append(item)
    }

    mutating func pop() -> Int {
        return items.removeLast()
    }
}

var intStack = IntStack()
intStack.push(10)
intStack.push(11)
print("before pop = \(intStack.items))")
intStack.pop()
print("after pop = \(intStack.items)")


struct StringStack {
    var items: [String] = []

    mutating func push(_ item: String) {
        items.append(item)
    }

    mutating func pop() -> String {
        return items.removeLast()
    }
}

var strStack = StringStack()
strStack.push("abc")
strStack.push("bnm")
print("before pop = \(strStack.items))")
strStack.pop()
print("after pop = \(strStack.items) \n")


print("generic \n")


struct Stack<Element> {
    var items: [Element] = []

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        return items.removeLast()
    }
}


var stack1 = Stack(items: [5,6,7])
stack1.push(8)
print("before pop = \(stack1.items))")
stack1.pop()
print("after pop = \(stack1.items)")


var stack2 = Stack(items: ["nm","as","df"])
stack2.push("sf")
print("before pop = \(stack2.items))")
stack2.pop()
print("after pop = \(stack2.items)")


 //Creating generic methods
// sample1
func printElement1<T: CustomStringConvertible>(_ element: T) {
    print(element)
}

// usig where clause
func printElement2<T>(_ element: T) where T: CustomStringConvertible {
    print(element)
}

// opaque types
func printElement3(_ element: some CustomStringConvertible) {
    print(element.description)
}

