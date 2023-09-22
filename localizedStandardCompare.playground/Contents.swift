// localizedStandardCompare() https://www.swiftwithvincent.com/blog/discover-localizedstandardcompare

import Foundation
/*
let fileNames = [
    "File 100.txt",
    "File 5.txt",
    "File 20.txt"
]


fileNames.sorted()
//  ["File 100.txt", "File 20.txt", "File 5.txt”]
// when you compare the Strings character by character, 1 does come before 2 and 2 does come before 5:

fileNames.sorted {
    $0.localizedStandardCompare($1) == .orderedAscending
}
//  ["File 5.txt", "File 20.txt", "File 100.txt”]
// localizedStandardCompare() -> function uses the current Locale in order to sort an array of strings in the same way the Finder app would


*/




public func solution(_ U: Int, _ weight: [Int]) -> Int {
    var weight2: [Int] = []
    
    for index in 0..<weight.count {
        if weight[index] <= U {
            if weight2.count == 0 {
                weight2.append(weight[index])
            } else {
                let currentWeight = weight[index]
                print(currentWeight)
                let previousWeight = weight2.last ?? 0
                print(previousWeight)
                
                if previousWeight + currentWeight <= U {
                    weight2.append(currentWeight)
                    print(weight2)
                } else if previousWeight > currentWeight{
                    print(weight2)
                    weight2 = weight2.dropLast(1)
                    print(weight2)
                    weight2.append(currentWeight)
                    print(weight2)
                }
            }
        }
    }
    
    if weight == weight2 {
        return 0
    }
    return weight2.count
}

var weight = [5, 3, 8, 1, 8, 7, 7, 6]// [7,6,5,2,7,4,5,4]//
let a = solution(9, weight)//solution2(9, weight)
print(a)

/*public func solution(_ N: Int) -> Int {
    if N <= 1 {
        return N
    }
    
    var first = 0
    var second = 1
    
    for _ in 2...N {
        let tempNum = (first + second) % 1000000
        first = second
        second = tempNum
    }
    
    return second
}

// Example usage:
let result = solution(36    ) // Should return 21
print(result)
*/
