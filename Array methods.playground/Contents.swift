import UIKit

/* array methods*/

var numbers = [21, 34, 54, 12]

print("Before Insert: \(numbers)")

numbers.insert(32, at: 1)

print("After insert: \(numbers)")

numbers.sort()
print("After sort : \(numbers)")

numbers.shuffle()
print("After shuffle : \(numbers)")

numbers.swapAt(0, numbers.count - 1)
print("After swap : \(numbers)")

numbers.swapAt(1, numbers.count - 1)
print("After swap2 : \(numbers)")

numbers.reverse()
print("After reverse : \(numbers)")

