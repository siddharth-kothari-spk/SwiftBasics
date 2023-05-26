import UIKit

// 1. Merge sort
print("--------------------------------------")
func mergeSort(_ array:[Int]) -> [Int] {
    
    guard array.count > 1 else {
        return array
    }
    
    let middle = array.count/2
    
    let left = mergeSort(Array(array[0..<middle]))
    let right = mergeSort(Array(array[middle..<array.count]))

    return merge(left,right)
}


func merge(_ left: [Int], _ right: [Int]) -> [Int] {
    
    var leftIndex = 0
    var rightIndex = 0
    
    var result: [Int] = [Int]()
    result.reserveCapacity(left.count + right.count)
    
    while leftIndex < left.count && rightIndex < right.count {
        if (left[leftIndex] < right[rightIndex]) {
            result.append(left[leftIndex])
            leftIndex += 1
        }
        else if (left[leftIndex] > right[rightIndex]){
            result.append(right[rightIndex])
            rightIndex += 1
        }
        else {
            result.append(left[leftIndex])
            leftIndex += 1
            result.append(right[rightIndex])
            rightIndex += 1
        }
    }
    
    while leftIndex < left.count {
        result.append(left[leftIndex])
        leftIndex += 1
    }
    
    while rightIndex < right.count {
        result.append(right[rightIndex])
        rightIndex += 1
    }
    
    return result
}


let mergetest  = [1, 4 , 2 , 9 , 5 , 7 , 10, 2]
print("merge sort: \(mergeSort(mergetest))")
print("--------------------------------------")


// 2. Bubble sort
print("--------------------------------------")
func bubbleSort(_ array:[Int]) -> [Int] {
    
    let lastPos = array.count - 1
    var swapped = true
    var newArr = array
    while swapped {
        swapped = false
        
        for i in 0..<lastPos {
            if newArr[i] > newArr[i+1] {
                newArr.swapAt(i+1, i)
                swapped = true
            }
        }
    }
    
    return newArr
}

let bubbletest = [3, 2 , 7 , 4 , 14 , 12 , 11, 3]
print("bubble sort: \(bubbleSort(bubbletest))")
print("--------------------------------------")


// 3. Insertion sort
print("--------------------------------------")
func insertionSort(_ array:[Int]) -> [Int] {
    var newArr = array
    
    for index in 1..<newArr.count {
        var idx = index
        while idx > 0 && newArr[idx] < newArr[idx-1] {
            newArr.swapAt(idx-1, idx)
            idx -= 1
        }
    }
    return newArr
}

let insertiontest = [10, -3 , 4 , 6 , 2 , 7]
print("insertion sort: \(insertionSort(insertiontest))")
print("--------------------------------------")



// 4. bucket sort

print("--------------------------------------")
// main function
public func bucketSort<T:Sortable>(elements: [T],
                                distributor: Distributor,
                                     sorter: Sorter,
                                    buckets: [Bucket<T>]) -> [T] {
    precondition(allPositiveNumbers(elements))
    precondition(enoughSpaceInBuckets(buckets, elements: elements))

    var bucketsCopy = buckets
    for elem in elements {
        distributor.distribute(element: elem, buckets: &bucketsCopy)
    }

    var results = [T]()

    for bucket in bucketsCopy {
        results += bucket.sort(algorithm: sorter)
    }

    return results
}

// precondition

private func allPositiveNumbers<T: Sortable>(_ array: [T]) -> Bool {
    return array.filter { $0.toInt() >= 0 }.count > 0
}

private func enoughSpaceInBuckets<T>(_ buckets: [Bucket<T>], elements: [T]) -> Bool {
    let maximumValue = elements.max()?.toInt()
    print("maximumValue = \(String(describing: maximumValue))")
    let totalCapacity = buckets.count * (buckets.first?.capacity)!
    print("totalCapacity = \(String(describing: totalCapacity))")
    guard let max = maximumValue else {
        return false
    }
    
    return totalCapacity >= max
}
// bucket
public struct Bucket<T:Sortable> {
    var elements: [T]
    let capacity: Int

    public init(capacity: Int) {
        self.capacity = capacity
        elements = [T]()
    }

    public mutating func add(item: T) {
        if (elements.count < capacity) {
            elements.append(item)
        }
    }

    public func sort(algorithm: Sorter) -> [T] {
        return algorithm.sort(items: elements)
    }
}

// protocols
public protocol Sortable: IntConvertible, Comparable {
}
public protocol IntConvertible {
    func toInt() -> Int
}
public protocol Sorter {
    func sort<T:Sortable>(items: [T]) -> [T]
}
public protocol Distributor {
    func distribute<T:Sortable>(element: T, buckets: inout [Bucket<T>])
}


// custom sorter

public struct InsertionSorter: Sorter {
    public func sort<T:Sortable>(items: [T]) -> [T] {
        var results = items
        for i in 0 ..< results.count {
            var j = i
            while ( j > 0 && results[j-1] > results[j]) {
                results.swapAt(j-1, j)
                j -= 1
            }
        }
        return results
    }
}

// distributor

/*
 * An example of a simple distribution function that send every elements to
 * the bucket representing the range in which it fits.
 *
 * If the range of values to sort is 0..<49 i.e, there could be 5 buckets of capacity = 10
 * So every element will be classified by the ranges:
 *
 * -  0 ..< 10
 * - 10 ..< 20
 * - 20 ..< 30
 * - 30 ..< 40
 * - 40 ..< 50
 *
 * By following the formula: element / capacity = #ofBucket
 */
public struct RangeDistributor: Distributor {
    public func distribute<T:Sortable>(element: T, buckets: inout [Bucket<T>]) {
     let value = element.toInt()
     let bucketCapacity = buckets.first!.capacity

     let bucketIndex = value / bucketCapacity
        buckets[bucketIndex].add(item: element)
    }
}

//

extension Int: IntConvertible, Sortable {
    public func toInt() -> Int {
        return self
    }
}

//let testbucket = [0.2, 1, 0.1, 10, 11, 100, 99, 81]

let input = [1, 2, 4, 6, 10, 5]
var buckets = [Bucket<Int>(capacity: 15), Bucket<Int>(capacity: 15), Bucket<Int>(capacity: 15)]
// var buckets = [Bucket<Int>(capacity: 11)]
let sortedElements = bucketSort(elements: input, distributor: RangeDistributor(), sorter: InsertionSorter(), buckets: buckets)

print("bucket sort: \(sortedElements)")
print("--------------------------------------")



// bucket sort via chaGPT
print("--------------------------------------")
func bucketSort(_ array: [Int]) -> [Int] {
    // create an array of empty lists
    var buckets = [[Int]](repeating: [], count: array.count)

    // distribute the elements of the input array into the buckets
    for element in array {
        let index = Int(element / array.count)
        buckets[index].append(element)
    }

    // sort each non-empty bucket
    for i in 0..<buckets.count {
        if !buckets[i].isEmpty {
            buckets[i] = buckets[i].sorted()
        }
    }

    // concatenate the sorted buckets to obtain the sorted array
    var result = [Int]()
    for bucket in buckets {
        result += bucket
    }
    return result
}

let inputBucket = [1, 2, 4, 6, 10, 5]
print("bucket sort 2: \(bucketSort(inputBucket))")
print("--------------------------------------")



// 5. Quick sort
print("--------------------------------------")
func quickSort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else { return array }

    let pivot = array[array.count/2]
    let less = array.filter { $0 < pivot }
    let equal = array.filter { $0 == pivot }
    let greater = array.filter { $0 > pivot }

    return quickSort(less) + equal + quickSort(greater)
}

let inputQuick = [1, 2, 4, 6, 10, 5]
print("quick sort: \(quickSort(inputQuick))")
print("--------------------------------------")

// 6. Counting sort
print("--------------------------------------")
func countingSort(_ array: inout [Int]) {
    let maxValue = array.max() ?? 0
    var count = [Int](repeating: 0, count: maxValue + 1)

    for element in array {
        count[element] += 1
    }

    var index = 0
    for i in 0...maxValue {
        for _ in 0..<count[i] {
            array[index] = i
            index += 1
        }
    }
}

var array = [3, 2, 1, 4, 3, 2, 1]
countingSort(&array)
print("counting sort: \(array)")  // [1, 1, 2, 2, 3, 3, 4]
print("--------------------------------------")


// 7. Heap sort
print("--------------------------------------")
func heapify(arr: inout [Int], length: Int, index: Int) {
    var largest = index
    let l = 2 * index + 1
    let r = 2 * index + 2
  
    if l < length && arr[l] > arr[largest] {
        largest = l
    }
    if r < length && arr[r] > arr[largest] {
        largest = r
    }
  
    if largest != index {
        arr.swapAt(index, largest)
        heapify(arr: &arr, length: length, index: largest)
    }
}

func heapSort(arr: inout [Int]) {
    let n = arr.count
  
    for i in (0..<n/2).reversed() {
        print(i)
        print("before = \(arr)")
        heapify(arr: &arr, length: n, index: i)
        print("after = \(arr)")
    }
  
    for i in (1..<n).reversed() {
        arr.swapAt(0, i)
        heapify(arr: &arr, length: i, index: 0)
    }
}

var arrayHeap = [3, 2, 1, 4, 3, 2, 1]
heapSort(arr: &arrayHeap)
print("heap sort: \(arrayHeap)")
print("--------------------------------------")


// 8. Odd even sort
print("--------------------------------------")
func oddEvenSort(_ arr: inout [Int]) {
    var isSorted = false
    while !isSorted {
        isSorted = true
        for i in stride(from: 0, to: arr.count-1, by: 2) {
            if arr[i] > arr[i + 1] {
                arr.swapAt(i, i + 1)
                isSorted = false
            }
        }
        for i in stride(from: 1, to: arr.count-1, by: 2) {
            if arr[i] > arr[i + 1] {
                arr.swapAt(i, i + 1)
                isSorted = false
            }
        }
    }
}

var arrayOddEven = [3, 2, 1, 4, 3, 2, 1]
oddEvenSort(&arrayOddEven)
print("odd even sort: \(arrayOddEven)")
print("--------------------------------------")



// 9. Selection sort
print("--------------------------------------")
func selectionSort(_ array: inout [Int]) {
    for i in 0..<array.count {
        var minIndex = i
        for j in i+1..<array.count {
            if array[j] < array[minIndex] {
                minIndex = j
            }
        }
        if minIndex != i {
            array.swapAt(i, minIndex)
        }
    }
}
var arraySelection = [3, 2, 1, 4, 3, 2, 1]
selectionSort(&arraySelection)
print("selection sort: \(arraySelection)")
print("--------------------------------------")
