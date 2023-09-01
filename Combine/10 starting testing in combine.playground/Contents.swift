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

class CarViewModelTest: XCTestCase {
  var car: Car!
  var carViewModel: CarViewModel!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    car = Car()
    carViewModel = CarViewModel(car: car)
    cancellables = []
  }

  func testCarViewModelEmitsCorrectStrings() {
    // determine what kwhInBattery would be after driving 10km
    let newValue: Double = car.kwhInBattery - car.kwhPerKilometer * 10

    // configure an array of expected output
    var expectedValues = [car.kwhInBattery, newValue].map { doubleValue in
      return "The car now has \(doubleValue)kwh in its battery"
    }

    // expectation to be fulfilled when we've received all expected values
    let receivedAllValues = expectation(description: "all values received")

    // subscribe to the batterySubject to run the test
      carViewModel.batterySubject.sink(receiveValue: { value in
          guard  let expectedValue = expectedValues.first else {
              XCTFail("Received more values than expected.")
              return
          }
          
          guard expectedValue == value else {
              XCTFail("Expected received value \(value) to match first expected value \(expectedValue)")
              return
          }
          
          // remove the first value from the expected values because we no longer need it
          expectedValues = Array(expectedValues.dropFirst())
          if expectedValues.isEmpty {
                  // the  test is completed when we've received all expected values
                  receivedAllValues.fulfill()
                }
              }).store(in: &cancellables)

              // call drive to trigger a second value
              carViewModel.drive(kilometers: 10)

              // wait for receivedAllValues to be fulfilled
              waitForExpectations(timeout: 1, handler: nil)
            }
          }

//testing my Combine code by comparing an array of expected values to the values that are emitted by batterySubject. The first element in the expectedValues array is always the element that I expect to receive from batterySubject. After receiving a value, I use dropFirst() to create a new expectedValues array with all elements from the old expectedValues array, except for the first value. I drop the first value because I just received that value.


