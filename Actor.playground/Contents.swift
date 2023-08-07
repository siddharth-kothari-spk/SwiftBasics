//courtsey:
//https://medium.com/@letadas/simplifying-concurrent-programming-with-swift-actors-26bd8840e5c6
//https://www.swiftbysundell.com/articles/swift-actors/



// One of the core advantages of Swift’s new actor types is that they can help us prevent so-called “data races” — that is, memory corruption issues that can occur when two separate threads attempt to access or mutate the same data at the same time.


import Foundation

class BankAccount {
    var balance: Double = 0.0
    func deposit(amount: Double) {
        balance += amount
    }
    func withdraw(amount: Double) {
        if amount <= balance {
            balance -= amount
        } else {
            print("Insufficient funds!")
        }
    }
}

let account = BankAccount()
let group = DispatchGroup()

DispatchQueue.concurrentPerform(iterations: 5) { _ in
    group.enter()
    DispatchQueue.global().async {
        account.deposit(amount: 10.0)
        print("bal: \(account.balance)")
        group.leave()
    }
    group.enter()
    DispatchQueue.global().async {
        account.withdraw(amount: 5.0)
        print("bal: \(account.balance)")
        group.leave()
    }
}

group.wait()

print("Final balance: \(account.balance)")

/*
 sample output
 bal: 10.0
 bal: 20.0
 bal: 30.0
 bal: 20.0
 bal: 25.0
 bal: 25.0
 bal: 20.0
 bal: 35.0
 bal: 30.0
 bal: 25.0
 Final balance: 25.0
*/


