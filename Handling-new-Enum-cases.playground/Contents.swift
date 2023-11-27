//courtsey:https://medium.com/@sharaev_vl/handling-new-enum-cases-in-swift-unknowncasedecodable-protocol-08e54fa37aef
import UIKit

// Working with data that we decode as an enumeration always creeped us out due to possibility of new cases or changing the names of cases

/*
 Input Data

 Imagine that we have a task board, and it has 3 main sections: new, in progress, done. Each task has a title and a priority level: low/medium/high. The list of tasks we get from an API using JSON:
 
 [
   {
     "title": "Task #1",
     "status": "new",
     "priorityLevel": 50
   }
 ]
 */

struct Task: Decodable {
    let title: String
    let status: Status
    let priorityLevel: PriorityLevel
}

enum Status: String, Decodable {
    case new, inProgress, done
    case unknown // a safe case
}

enum PriorityLevel: Int, Decodable {
    case low = 25
    case medium = 50
    case high = 75
    case unknown // a safe case
}

do {
    let jsonURL = Bundle.main.url(forResource: "Tasks", withExtension: "json")!
    let (data, _) = try await URLSession.shared.data(from: jsonURL)
    let tasks = try JSONDecoder().decode([Task].self, from: data)

    print(tasks)
    // "[__lldb_expr_29.Task(title: "Task #1", status: __lldb_expr_29.Status.new, priorityLevel: __lldb_expr_29.PriorityLevel.medium)]"
} catch {
    print(error)
}

/*
 Issue #1: New cases

 Let’s say we need to add a new status - in review and a new priority level - highest. Let’s add these cases to our JSON.
 
 [
   {
     "title": "Task #1",
     "status": "inReview", <- changed
     "priorityLevel": 100  <- changed
   }
 ]
 
 Now , we get following error:
 
 "dataCorrupted(Swift.DecodingError.Context(codingPath: [_JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "status", intValue: nil)], debugDescription: "Cannot initialize Status from invalid String value inReview", underlyingError: nil))
 "
 
 Solution to the Issue #1: Adding an unknown case in both enum
 case unknown
 
 Now error:
 
 "dataCorrupted(Swift.DecodingError.Context(codingPath: [_JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "status", intValue: nil)], debugDescription: "Cannot initialize Status from invalid String value inReview", underlyingError: nil))
 "
 */

