import Foundation
// courtsey : https://www.avanderlee.com/swift/actors/

// Actor in Swift is inspired by Actor Model (https://en.wikipedia.org/wiki/Actor_model) to solve data races.
// Data races occur when the same memory is accessed from multiple threads without synchronization, and at least one access is a write.

// Actors are like other Swift types as they can also have initializers, methods, properties, and subscripts, while you can also use them with protocols and generics. Actors are reference types but they do not support inheritance.

// Before Actor:

final class ChickenFeederWithQueue {
    let food = "Worms"
    
    /// A concurrent queue to allow multiple reads at once.
    private var queue = DispatchQueue(label: "chicken.feeder.queue", attributes: .concurrent)
    
    /// A combination of a private backing property and a computed property allows for synchronized access.
    private var _numberOfEatingChickens: Int = 0
    var numberOfEatingChickens: Int {
        queue.sync {
            _numberOfEatingChickens
        }
    }
    
    func chickenStartsEating() {
        /// Using a barrier to stop reads while writing
        queue.sync(flags: .barrier) {
            _numberOfEatingChickens += 1
        }
    }
    
    func chickenStopsEating() {
        /// Using a barrier to stop reads while writing
        queue.sync(flags: .barrier) {
            _numberOfEatingChickens -= 1
        }
    }
}

// After Actor:
actor ChickenFeeder {
    let food = "worms"
    var numberOfEatingChickens: Int = 0
    
    func chickenStartsEating() {
        numberOfEatingChickens += 1
    }
    
    func chickenStopsEating() {
        numberOfEatingChickens -= 1
    }
}
