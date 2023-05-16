import UIKit

func fetchNumbers() async -> [Int] {
    return [2, 5 ,4 , 8 ,7 , 3]
}

func fetchNumber() async -> Int {
    return Int.random(in: 1...100)
}
func calculateTotal(for numbers:[Int]) async -> Int {
    return numbers.reduce(0, +)
}

func printOP(op n:Int) async -> String {
    return "The o/p is \(n)"
}

func process1() async {
    let numbers = await fetchNumbers()
    print(" process1 numbers:\(numbers)")
    let total = await calculateTotal(for: numbers)
    print(" process1 total:\(total)")
    let op = await printOP(op: total)
    print(" process1 output:\(op)")
}

func process2() async {
    // here though each number call is independent num fetch will happen synchronously
    let number1 = await fetchNumber()
    let number2 = await fetchNumber()
    let number3 = await fetchNumber()
    let numbers = [number1,number2,number3]
    print(" process2 numbers:\(numbers)")
    let total = await calculateTotal(for: numbers)
    print(" process2 total:\(total)")
    let op = await printOP(op: total)
    print(" process2 output:\(op)")
}


// to enable parallel calls

func process3() async {
    // here though each number call is independent num fetch will happen synchronously
    async let number1 =  fetchNumber()
    async let number2 =  fetchNumber()
    async let number3 =  fetchNumber()
    let numbers = await [number1,number2,number3]
    print(" process3 numbers:\(numbers)")
    let total = await calculateTotal(for: numbers)
    print(" process3 total:\(total)")
    let op = await printOP(op: total)
    print(" process3 output:\(op)")
}


Task {
    print("process1 start")
    await process1()
    print("process1 end")
}



Task {
    print("process3 start")
    await process3()
    print("process3 end")
}


Task {
    print("process2 start")
    await process2()
    print("process2 end")
}

print("extra method to check async/await start")
func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
    var dict: [Int: Int] = [:]
    for num in nums { dict[num, default: 0] += 1 }
    print("dict : \(dict)")
    return dict.sorted(by: { $0.value > $1.value })[0..<k].map(\.key)
}

print("topKFrequent = \(topKFrequent([1,2,3,4,3,2,1], 2))")
print("extra method to check async/await finish")


/*
 sample output 1:
 
 process1 start
  process1 numbers:[2, 5, 4, 8, 7, 3]
 extra method to check async/await start
  process1 total:29
 dict : [2: 2, 1: 2, 3: 2, 4: 1]
  process1 output:The o/p is 29
 process1 end
 process3 start
 process2 start
 topKFrequent = [2, 1]
 extra method to check async/await finish
  process2 numbers:[47, 29, 16]
  process2 total:92
  process2 output:The o/p is 92
 process2 end
  process3 numbers:[51, 76, 32]
  process3 total:159
  process3 output:The o/p is 159
 process3 end

 
 sample output 2:
 
 process1 start
  process1 numbers:[2, 5, 4, 8, 7, 3]
 extra method to check async/await start
  process1 total:29
  process1 output:The o/p is 29
 process1 end
 process3 start
 process2 start
 dict : [2: 2, 1: 2, 4: 1, 3: 2]
  process2 numbers:[62, 22, 44]
  process2 total:128
  process2 output:The o/p is 128
 process2 end
  process3 numbers:[6, 28, 4]
  process3 total:38
  process3 output:The o/p is 38
 process3 end
 topKFrequent = [2, 1]
 extra method to check async/await finish
*/

