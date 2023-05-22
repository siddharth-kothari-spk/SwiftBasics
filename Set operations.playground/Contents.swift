import UIKit

// Swift Set Operations
// 1. Union

// first set
let setA: Set = [1, 3, 5]
print("Set A: ", setA)

// second set
let setB: Set = [0, 2, 4]
print("Set B: ", setB)

// perform union operation
print("Union: ", setA.union(setB))
print("----------------------------")

// 2. Intersection

// first set
let setA1: Set = [1, 3, 5]
print("Set A: ",  setA1)

// second set
let setB1: Set = [1, 2, 3]
print("Set B: ",  setB1)

// perform intersection operation
print("Intersection: ", setA1.intersection(setB1))
print("----------------------------")

// 3. Difference between Two Sets

// first set
let setA2: Set = [2, 3, 5]
print("Set A: ",  setA2)

// second set
let setB2: Set = [1, 2, 6]
print("Set B: ",  setB2)

// perform subtraction operation
print("Subtraction: ", setA2.subtracting(setB2))

print("----------------------------")
// 4. Symmetric Difference between Two Sets

// first set
let setA3: Set = [2, 3, 5]
print("Set A: ",  setA3)

// second set
let setB3: Set = [1, 2, 6]
print("Set B: ",  setB3)

// perform symmetric difference operation
print("Symmetric Difference: ", setA3.symmetricDifference(setB3))

print("----------------------------")
// 5. Subset

// first set
let setA4: Set = [1, 2, 3, 5, 4]
print("Set A: ",  setA4)

// second set
let setB4: Set = [1, 2,9]
print("Set B: ",  setB4)

// check if setB is subset of setA or not
print("Subset: ", setB4.isSubset(of: setA4))

print("----------------------------")
// 6. subsets are equal

let setA5: Set = [1, 3, 5]
print("Set A: ",  setA5)
let setB5: Set = [3, 5, 1]
print("Set B: ",  setB5)

if setA5 == setB5 {
  print("Set A and Set B are equal")
}
else {
  print("Set A and Set B are different")
}
