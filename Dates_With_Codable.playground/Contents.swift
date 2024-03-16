/*
 https://www.donnywals.com/working-with-dates-and-codable-in-swift/
 */

import Foundation

var jsonData = """
[
    {
        "title": "Grocery shopping",
        "date": 730976400.0
    },
    {
        "title": "Dentist appointment",
        "date": 731341800.0
    },
    {
        "title": "Finish project report",
        "date": 731721600.0
    },
    {
        "title": "Call plumber",
        "date": 732178800.0
    },
    {
        "title": "Book vacation",
        "date": 732412800.0
    }
]
""".data(using: .utf8)!

struct ToDoItem: Codable {
  let title: String
  let date: Date
}

// number of seconds since January 1st 2001
// dateDecodingStrategy = .deferredToDate
do {
    let decoder = JSONDecoder() // default: deferredToDate
    let todos = try decoder.decode([ToDoItem].self, from: jsonData)
    print(todos)
} catch {
    print(error)
}

print("------------------------------------")
// dateDecodingStrategy = .secondsSince1970
do {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970
  let todos = try decoder.decode([ToDoItem].self, from: jsonData)
  print(todos)
} catch {
  print(error)
}
