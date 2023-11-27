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

enum Status: String, UnknownCaseDecodable {
    typealias DecodeType = String
    
    case new, inProgress, done
    case unknown // a safe case
}

enum PriorityLevel: Int, UnknownCaseDecodable {
    typealias DecodeType = Int
    
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
 
 For this to work, We need to write new initializers from decoder.
 */

/*
extension Status {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try container.decode(String.self)
        self = .init(rawValue: type) ?? .unknown // magic is here
    }
}

extension PriorityLevel {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try container.decode(Int.self)
        self = .init(rawValue: type) ?? .unknown // magic is here
    }
} */

/*
 Now output :
 
 "[__lldb_expr_3.Task(title: "Task #1", status: __lldb_expr_3.Status.new, priorityLevel: __lldb_expr_3.PriorityLevel.medium), __lldb_expr_3.Task(title: "Task #2", status: __lldb_expr_3.Status.unknown, priorityLevel: __lldb_expr_3.PriorityLevel.unknown)]
 "
 */


/*
 Issue #2: Initializers

 Every time when we need to implement an unknown case, we have to implement an initializer via decoder. This code is going to be copy-pasted again and again for each enumeration.
 
 Solution to the Issue #2: Adding an UnknownCaseDecodable protocol
 */

protocol UnknownCaseDecodable: Decodable where Self: RawRepresentable {
    associatedtype DecodeType: Decodable where DecodeType == RawValue
    
    static var unknown: Self { get }
    var rawValue: DecodeType { get } //As far as our enums have rawValue, we don’t need to directly specify the type to conform UnknownCaseDecodable.
}

extension UnknownCaseDecodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try container.decode(DecodeType.self)
        self = .init(rawValue: type) ?? Self.unknown
    }
}

/*
 Our protocol conforms to the protocol Decodable.
 Our protocol is intended only for enumerations, because Self: RawRepresentable.
 Our protocol is generic. Thus, both of our enumerations can implement this protocol.
 Our protocol has static variable unknown, since Swift 5.3 enums can use protocol’s static variables as cases: source.
 Our protocol has a default initializer implementation.
 
 Now we dont need Status and PriorityLevel Extensions
 Now output:
 
 "[__lldb_expr_3.Task(title: "Task #1", status: __lldb_expr_3.Status.new, priorityLevel: __lldb_expr_3.PriorityLevel.medium), __lldb_expr_3.Task(title: "Task #2", status: __lldb_expr_3.Status.unknown, priorityLevel: __lldb_expr_3.PriorityLevel.unknown)]
 "
 */

