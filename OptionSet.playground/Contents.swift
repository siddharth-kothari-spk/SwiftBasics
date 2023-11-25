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

