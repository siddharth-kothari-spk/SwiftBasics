// https://levelup.gitconnected.com/mastering-enums-in-swift-a-comprehensive-guide-3fb4394445a3

// Enums without associated values

///Enums without associated values are easier to use because they don’t hold any additional data for each scenario.
enum Day: CaseIterable {
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

// Enums with associated values

/// Enums with associated values enable us to store extra data alongside each case.

enum Temperature {
  case celsius(Double)
  case fahrenheit(Double)
  case kelvin(Double)
}

let tempInCelsius = Temperature.celsius(27.0)
print(tempInCelsius)
let tempInFahrenheit = Temperature.fahrenheit(83.0)
print(tempInFahrenheit)
let tempInKelvin = Temperature.kelvin(373.0)
print(tempInKelvin)

// Enums with raw values

/// Raw values, which are connected to each case, are another option for enums. Any type of value, whether Int, String, or Double, can be a raw value.

enum Planet: Int {
    case mercury = 1
    case venus
    case earth
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    case pluto
}

let earth = Planet(rawValue: 3)!
print(earth)


// Enums with computed attributes and methods

/// The same as classes and structs, enums can have calculated properties and methods.

enum TemperatureWithMethod {
    case celsius(Double)
    case fahrenheit(Double)
    case kelvin(Double)

    var celsiusValue: Double {
        switch self {
        case .celsius(let value):
            return value
        case .fahrenheit(let value):
            return (value - 32) * (5/9)
        case .kelvin(let value):
            return value - 273.15
        }
    }

    func compare(to otherTemperature: TemperatureWithMethod) -> String {
        let selfCelsius = self.celsiusValue
        let otherCelsius = otherTemperature.celsiusValue
        
        if selfCelsius > otherCelsius {
            return "Higher"
        } else if selfCelsius < otherCelsius {
            return "Lower"
        } else {
            return "Equal"
        }
    }
}

let temp1 = TemperatureWithMethod.fahrenheit(83.0)
let temp2 = TemperatureWithMethod.celsius(27.0)

print(temp1.compare(to: temp2))

// Enums with custom initializers

/// In the same way as classes and structs do, enums can likewise have custom initializers. This can be helpful for offering many methods of initializing an enum value.

enum TemperatureWithInitializer {
    case celsius(Double)
    case fahrenheit(Double)
    case kelvin(Double)

    init(value: Double, scale: String) {
        switch scale.lowercased() {
        case "celsius":
            self = .celsius(value)
        case "fahrenheit":
            self = .fahrenheit(value)
        case "kelvin":
            self = .kelvin(value)
        default:
            self = .celsius(value)
        }
    }
}

let temp3 = TemperatureWithInitializer(value: 77.0, scale: "Fahrenheit")
let temp4 = TemperatureWithInitializer(value: 25.0, scale: "Celsius")


// Enume cases as function parameters

///Like any other value, enum cases can be utilized as function parameters.

func getActivities(for day: Day) -> [String] {
    switch day {
    case .monday:
        return ["go to soccer"]
    case .tuesday:
        return ["go to library"]
    case .wednesday:
        return ["visit friends"]
    case .thursday:
        return ["go to arts class"]
    case .friday:
        return ["go to shop"]
    case .saturday:
        return ["tidy up room"]
    case .sunday:
        return ["go to baseball match"]
    }
}

let dayActivities = getActivities(for: .wednesday)
print(dayActivities)

// Iterating through the enum cases

///The allCases attribute of an enum allows us to repeatedly loop through all of its cases.

for day in Day.allCases {
    print(day)
}
