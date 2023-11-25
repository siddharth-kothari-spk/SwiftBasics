// courtsey: https://betterprogramming.pub/what-is-optionset-in-swift-and-when-you-should-use-it-419777f3c39

import Foundation

/*
 We use OptionSet to represent and work in a type-safe way with a group of related members (or options). Its concept is similar to the enum, but it has some quite useful features that are not available in mere enumerations.
 
 Say we’re developing a project management tool and want to have tasks of different importance and difficulty. The standard way to do this is with an enumeration:
 */

enum TaskType {
    case urgent
    case notUrgent
    case easy
    case hard
}

struct Task {
    let title: String
    let taskType: TaskType
    
    init(title: String, taskType: TaskType) {
        self.title = title
        self.taskType = taskType
    }
}

let task = Task(title: "Not urgent task", taskType: .notUrgent)

// But what if we want our Item to be both not urgent and easy? We have to make the taskType property an array and change its signature to taskTypes:

struct TaskMultiple {
    let title: String
    let taskTypes: [TaskType]
    
    init(title: String, taskTypes: [TaskType]) {
        self.title = title
        self.taskTypes = taskTypes
    }
}

let taskMultiple = TaskMultiple(title: "Not urgent and easy task", taskTypes: [.notUrgent, .easy])

// Now, to check if the item is both not urgent and easy, we write this relatively long if statement:
if taskMultiple.taskTypes.contains(.notUrgent) && taskMultiple.taskTypes.contains(.easy) {
    print("The item is easy and not urgent")
}

// We also want the taskTypes array to contain only unique members (no two .notUrgents allowed). So we transform this array into a Set

struct TaskMultipleSet {
    let title: String
    let taskTypes: Set<TaskType>
    
    init(title: String, taskTypes: [TaskType]) {
        self.title = title
        self.taskTypes = Set(taskTypes)
    }
}

// OptionSet Implementation

//Let’s perform the tasks above but with an OptionSet instead of an enum

struct TaskTypes: OptionSet {
    let rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let urgent = TaskTypes(rawValue: 1 << 0) // 1
    public static let notUrgent = TaskTypes(rawValue: 1 << 1) // 2
    public static let easy = TaskTypes(rawValue: 1 << 2) // 4
    public static let hard = TaskTypes(rawValue: 1 << 3) // 8
}

/*
 When we conform to the OptionSet protocol, it’s required that we provide a rawValue for the structure. According to Apple’s documentation, we can use types that conform to the FixedWidthInteger, such as Int, or UInt8.

 If we look at the urgent property, we see the following pattern: 1 << 0. The left value represents an integer multiplied by two in the power of the value on the right side. To clarify, one should be multiplied by two in the power of zero: 1 * 2⁰ = 1.

 Accordingly, the rawValue for the notUrgent is 1 << 1. So one is being multiplied by two in the power of one: 1 * 2¹ = 2. Because of this bit operation, we have a unique value for each member of a set.
 */

struct TaskOptionSet {
    let title: String
    var taskTypes: TaskTypes

    init(title: String, taskTypes: TaskTypes) {
        self.title = title
        self.taskTypes = taskTypes
    }
}

let taskTypes: TaskTypes = [.notUrgent, .easy]
let taskOptionSet = TaskOptionSet(title: "Not urgent task", taskTypes: taskTypes)

if taskOptionSet.taskTypes.contains([.notUrgent, .easy]) {
    print("The task is easy and not urgent")
}

// We can now perform Set-related operations, like intersection:
let taskOptionSet1 = TaskOptionSet(title: "Urgent but easy task", taskTypes: [.urgent, .easy])
let taskOptionSet2 = TaskOptionSet(title: "Urgent and hard task", taskTypes: [.urgent, .hard])

print(taskOptionSet1.taskTypes.intersection(taskOptionSet2.taskTypes))
// Prints a rawValue of 1, because the common member is .urgent

// Or union

let taskOptionSet3 = TaskOptionSet(title: "Urgent task", taskTypes: [.urgent])
let taskOptionSet4 = TaskOptionSet(title: "Hard task", taskTypes: [.hard])

print(taskOptionSet3.taskTypes.union(taskOptionSet4.taskTypes))
// This code prints the value of 9, because .urgent corresponds to 1, while .hard corresponds to 8. Their sum is 9, which is unique and can be obtained only when performing union with .urgent and .hard


