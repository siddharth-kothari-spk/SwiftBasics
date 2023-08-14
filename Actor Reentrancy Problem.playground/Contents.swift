/// courtsey: https://swiftsenpai.com/swift/actor-reentrancy-problem/
///
import UIKit

actor BankAccount {
    
    private var balance = 1000
    
    func withdraw(_ amount: Int) async {
        
        print("🤓 Check balance for withdrawal: \(amount)")
        
        guard canWithdraw(amount) else {
            print("🚫 Not enough balance to withdraw: \(amount)")
            return
        }
        
        guard await authorizeTransaction() else {
            return
        }
        
        print("✅ Transaction authorized: \(amount)")
        
        balance -= amount
        
        print("💰 Account balance: \(balance)")
    }
    
    private func canWithdraw(_ amount: Int) -> Bool {
        return amount <= balance
    }
    
    private func authorizeTransaction() async -> Bool {
        
        // Wait for 1 second
        try? await Task.sleep(nanoseconds: 1 * 1000000000)
        
        return true
    }
}

// Simulating the Reentrancy Problem
//Now, let’s consider a situation where 2 withdrawals happen concurrently. We can simulate that by triggering the withdraw(_:) function in 2 separate asynchronous tasks.


let account = BankAccount()

Task {
    await account.withdraw(800)
}

Task {
    await account.withdraw(500)
}
/*
 OUTPUT:
 🤓 Check balance for withdrawal: 800
 🤓 Check balance for withdrawal: 500
 ✅ Transaction authorized: 800
 💰 Account balance: 200
 ✅ Transaction authorized: 500
 💰 Account balance: -300
 */

/*
 Now let’s take a closer look at the withdraw(_:) function implementation, you will notice that the problem we currently face is actually caused by the following 3 reasons:

 A suspension point exists in the withdraw(_:) function, which is the await authorizeTransaction().
 The BankAccount‘s state (the balance value) for the 2nd transaction is different before and after the suspension point.
 The withdraw(_:) function is being called before its previous execution is completed.
 Because of the suspension point in the withdraw(_:) function, the balance check for the 2nd transaction happens before the 1st transaction is completed.
 This is a very typical reentrancy problem and it seems like Swift actors will not give us any compiler error when it happens.
 */

// Solution 1 :
// The first approach suggested by Apple engineers is to always mutate the actor state in synchronous code.

extension BankAccount {
    func withdrawMutateSynchronous(_ amount: Int) async {
        
        // Perform authorization before check balance
        guard await authorizeTransaction() else {
            return
        }
        print("✅ Transaction authorized: \(amount)")
        
        print("🤓 Check balance for withdrawal: \(amount)")
        guard canWithdraw(amount) else {
            print("🚫 Not enough balance to withdraw: \(amount)")
            return
        }
        
        balance -= amount
        
        print("💰 Account balance: \(balance)")
        
    }
}

Task {
    await account.withdrawMutateSynchronous(900)
}

Task {
    await account.withdrawMutateSynchronous(300)
}

/*
 OUTPUT:
 ✅ Transaction authorized: 300
 🤓 Check balance for withdrawal: 300
 💰 Account balance: 700
 ✅ Transaction authorized: 900
 🤓 Check balance for withdrawal: 900
 🚫 Not enough balance to withdraw: 900
 */

// the withdrawal workflow doesn’t really make sense. What’s the point of authorizing a transaction if the account has insufficient balance?

// Solution 2:
// Check the Actor State After a Suspension Point

extension BankAccount {
    func withdrawAfterActorStateCheck(_ amount: Int) async {
        
        print("🤓 Check balance for withdrawal: \(amount)")
        guard canWithdraw(amount) else {
            print("🚫 Not enough balance to withdraw: \(amount)")
            return
        }
        
        guard await authorizeTransaction() else {
            return
        }
        print("✅ Transaction authorized: \(amount)")
        
        // Check balance again after the authorization process
        guard canWithdraw(amount) else {
            print("⛔️ Not enough balance to withdraw: \(amount) (authorized)")
            return
        }

        balance -= amount
        
        print("💰 Account balance: \(balance)")
        
    }
}

Task {
    await account.withdrawAfterActorStateCheck(800)
}

Task {
    await account.withdrawAfterActorStateCheck(700)
}

/*
 OUTPUT:
 🤓 Check balance for withdrawal: 800
 🤓 Check balance for withdrawal: 700
 ✅ Transaction authorized: 800
 💰 Account balance: 200
 ✅ Transaction authorized: 700
 ⛔️ Not enough balance to withdraw: 700 (authorized)
 */
