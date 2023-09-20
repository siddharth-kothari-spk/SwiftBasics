// https://levelup.gitconnected.com/mastering-enums-in-swift-a-comprehensive-guide-3fb4394445a3

// Enums without associated values

///Enums without associated values are easier to use because they don’t hold any additional data for each scenario.
enum Day {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

let currentday = Day.monday
print(currentday)
