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


// Custom Value type incorporating Copy On Write

@dynamicMemberLookup
protocol CopyOnWrite {
    associatedtype Storage: AnyObject & Copyable
    
    var _storage: Storage { get set }
}

extension CopyOnWrite {
    subscript<Value>(dynamicMember keypath: ReferenceWritableKeyPath<Storage, Value>) -> Value {
        get {
            return _storage[keyPath: keypath]
        }
        set {
            if !isKnownUniquelyReferenced(&_storage) {
                _storage = _storage.copy()
            }
            self._storage[keyPath: keypath] = newValue
        }
    }
}

protocol Copyable {
    func copy() -> Self
}

struct LargeType: CopyOnWrite {
    typealias Storage = _Storage
    var _storage: _Storage
    
    init(value: String) {
        self._storage = _Storage(value: value)
    }
    
    final class _Storage: Copyable { // requires the `copy()` method
        var value: String
        
        init(value: String) {
            self.value = value
        }
        
        func copy() -> _Storage {
            return .init(value: self.value)
        }
    }
}

var first = LargeType(value: "first")
print(first.value) // first

var second = first
print(second.value) // first
print(first._storage === second._storage) // true

second.value = "second"
print(first.value) // first
print(second.value) // second
print(first._storage === second._storage) // false
/*

final class Ref<T> {
  var val : T
  init(_ v : T) {val = v}
}

struct Box<T> {
    var ref : Ref<T>
    init(_ x : T) { ref = Ref(x) }

    var value: T {
        get { return ref.val }
        set {
          if (!isKnownUniquelyReferenced(&ref)) {
            ref = Ref(newValue)
            return
          }
          ref.val = newValue
        }
    }
}

struct Car {
  let model = "M3"
  let year = "2004"
}

struct BoxCar<Car> {
    var ref : Ref<Car>
    init(_ x : Car) { ref = Ref(x) }

    var value: Car {
        get { return ref.val }
        set {
          if (!isKnownUniquelyReferenced(&ref)) {
            ref = Ref(newValue)
            return
          }
          ref.val = newValue
        }
    }
}

var car1 = BoxCar(Car())
var car2 = car1

print(address: car1)
print(address: car2)
// This code was an example taken from the swift repo doc file OptimizationTips
// Link: https://github.com/apple/swift/blob/master/docs/OptimizationTips.rst#advice-use-copy-on-write-semantics-for-large-values


 /*var box1: Box = Box(13.78)
  var box2: Box = box1
  
  print(address: box1)
  print(address: box2)
  
  box2.value = 15.98
  
  print(address: box1)
  print(address: box2)
  */
*/
