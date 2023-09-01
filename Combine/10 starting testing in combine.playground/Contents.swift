/// courtsey: https://www.donnywals.com/getting-started-with-testing-your-combine-code/
///
import Combine
// if you can test asynchronous code, you know how to test Combine code

// The major difference between testing code that uses Combine, and code that runs asynchronously is that your asynchronous code will typically produce a single result. Combine code can publish a stream of values which means you'll want to make sure that your publisher has published all of the values you expected.

public class Car {
  @Published public var kwhInBattery = 50.0
  let kwhPerKilometer = 0.14
}

public struct CarViewModel {
  var car: Car

  public lazy var batterySubject: AnyPublisher<String?, Never> = {
    return car.$kwhInBattery.map({ newCharge in
      return "The car now has \(newCharge)kwh in its battery"
    }).eraseToAnyPublisher()
  }()

  public mutating func drive(kilometers: Double) {
    let kwhNeeded = kilometers * car.kwhPerKilometer

    assert(kwhNeeded <= car.kwhInBattery, "Can't make trip, not enough charge in battery")

    car.kwhInBattery -= kwhNeeded
  }
}


// The CarViewModel in this example provides batterySubject publisher and we'll test that it publishes a new value every time we call drive(kilometers:). The drive(kilometers:) method is used to update the Car's kwhInBattery which means that $kwhInBattery should emit a new value, which is then transformed and the transformed value is them emitted by batterySubject.


