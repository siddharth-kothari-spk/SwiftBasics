/*
 | Function                   | Includes end value? |
 | -------------------------- | ------------------- |
 | `stride(from:to:by:)`      | ❌ No                |
 | `stride(from:through:by:)` | ✅ Yes               |

 */

var arr: [Int] = []

for index in stride(from: 0, to: 25, by: 5) {
    arr.append(index)
}

print("arr: \(arr)")
var arr2: [Int] = []

for index in stride(from: 0, through: 25, by: 5) {
    arr2.append(index)
}
print("arr2: \(arr2)")
