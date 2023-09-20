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

