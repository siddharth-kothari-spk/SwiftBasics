import UIKit

struct Queue<Element> {
    private var elements: [Element] = []
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }
    
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    func peek() -> Element? {
        return elements.first
    }
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    func count() -> Int {
        return elements.count
    }
}

/*
 In this example, we define a generic struct called Queue that can hold elements of any type. The queue is implemented using an array as the underlying data structure.

 The enqueue method is used to add an element to the back of the queue by appending it to the elements array.

 The dequeue method removes and returns the element at the front of the queue by using the removeFirst function on the elements array. It returns nil if the queue is empty.

 The peek method returns the element at the front of the queue without removing it. It uses the first property on the elements array.

 The isEmpty method checks if the queue is empty by calling the isEmpty function on the elements array.

 The count method returns the number of elements currently in the queue by accessing the count property of the elements array.
 */

var queue = Queue<Int>()

queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)

print(queue.peek())   // Output: Optional(1)
print(queue.dequeue()) // Output: Optional(1)
print(queue.count())  // Output: 2
print(queue.isEmpty()) // Output: false

var queue2 = Queue<String>()

queue2.enqueue("abc")
queue2.enqueue("qwe")
queue2.enqueue("sid")

print(queue2.peek())   // Output: Optional("abc")
print(queue2.dequeue()) // Output: Optional("abc")
print(queue2.count())  // Output: 2
print(queue2.isEmpty()) // Output: false


