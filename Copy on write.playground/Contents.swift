/// courtsey: https://medium.com/@lucianoalmeida1/understanding-swift-copy-on-write-mechanisms-52ac31d68f2f
/// https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#:~:text=large%20Swift%20values-,Advice%3A%20Use%20copy%2Don%2Dwrite%20semantics%20for%20large%20values,-Unsafe%20code
///
import Foundation

func print(address o: UnsafeRawPointer ) {
    print(String(format: "%p", Int(bitPattern: o)))
}

var array1: [String] = ["abc", "def", "ghi"]
var array2 = array1

print(address: array1) // 0x600000ba06b0
print(address: array2) // 0x600000ba06b0

array2.append("jkl")

print(address: array1) // 0x600000ba06b0
print(address: array2) // 0x6000006ae920


