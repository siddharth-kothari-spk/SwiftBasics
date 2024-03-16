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


print("------------------------------------")
// dateDecodingStrategy = .iso8601
var jsonData2 = """
[
    {
        "title": "Grocery shopping",
        "date": "2024-03-01T10:00:00+01:00"
    },
    {
        "title": "Dentist appointment",
        "date": "2024-03-05T14:30:00+01:00"
    },
    {
        "title": "Finish project report",
        "date": "2024-03-10T23:59:00+01:00"
    },
    {
        "title": "Call plumber",
        "date": "2024-03-15T08:00:00+01:00"
    },
    {
        "title": "Book vacation",
        "date": "2024-03-20T20:00:00+01:00"
    }
]
""".data(using: .utf8)!

do {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601
  let todos = try decoder.decode([ToDoItem].self, from: jsonData2)
  print(todos)
} catch {
  print(error)
}


print("------------------------------------")
// custom encoding and decoding
var jsonData3 = """
[
    {
        "title": "Grocery shopping",
        "date": "2024-03-01"
    },
    {
        "title": "Dentist appointment",
        "date": "2024-03-05"
    },
    {
        "title": "Finish project report",
        "date": "2024-03-10"
    },
    {
        "title": "Call plumber",
        "date": "2024-03-15"
    },
    {
        "title": "Book vacation",
        "date": "2024-03-20"
    }
]
""".data(using: .utf8)!

do {
  let decoder = JSONDecoder()

  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd"
  formatter.locale = Locale(identifier: "en_US_POSIX")
  formatter.timeZone = TimeZone(secondsFromGMT: 0)

  decoder.dateDecodingStrategy = .formatted(formatter)

  let todos = try decoder.decode([ToDoItem].self, from: jsonData3)
  print(todos)
} catch {
  print(error)
}
