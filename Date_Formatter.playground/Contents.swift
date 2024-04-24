import Foundation

let now = Date()
let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

print(formatter.string(from: now)) // 24/04/2024


formatter.dateFormat = "DD/MM/yyyy" // DD - nth day of year
print(formatter.string(from: now)) // 115/04/2024

// from iOS 15 onwards
print(now.formatted()) // 24/04/2024, 11:40 PM

print(now.formatted(date: .numeric, time: .complete)) // 24/04/2024, 11:40:57 PM GMT+5:30
print(now.formatted(date: .complete, time: .complete)) // Wednesday, 24 April 2024 at 11:41:17 PM GMT+5:30

print(now.formatted(.dateTime.day(.twoDigits).month(.wide))) // 24 April
print(now.formatted(.dateTime.day(.twoDigits).month(.twoDigits))) // 24/04
print(now.formatted(.dateTime.dayOfYear(.defaultDigits))) // 115
print(now.formatted(.dateTime.day(.julianModified(minimumLength: 10)))) // 0002460425
print(now.formatted(.dateTime.day(.ordinalOfDayInMonth).era(.abbreviated).month(.defaultDigits).year(.defaultDigits).dayOfYear(.defaultDigits)))  // 4 2024 AD ├day of year: 115┤
