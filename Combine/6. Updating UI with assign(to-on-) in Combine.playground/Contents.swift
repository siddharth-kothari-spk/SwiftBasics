/// courtsey: https://www.donnywals.com/updating-ui-with-assigntoon-in-combine/
import Combine

// assign(to:on:). This subscriber is perfect for subscribing to publishers and updating your UI in response to new values.

// using sink method
class CarViewController: UIViewController {
  let car = Car()
  let label = UILabel()

  var cancellables = Set<AnyCancellable>()

  func subscribeToCarCharge() {
    car.$kwhInBattery.sink(receiveValue: { charge in
      self.label.text = "Car's charge is \(charge)"
    }).store(in: &cancellables)
  }

  // more VC code...
}

// we're using AnyCancellable's store(in:) method to retain the AnyCancellable that is returned by sink to avoid it from getting deallocated and tearing down the subscription as soon as as subscribeToCarCharge finishes executing.

//  using assign(to:on:) instead of sink:
func subscribeToCarCharge() {
  car.$kwhInBattery
    .map { "Car's charge is \($0)" }
    .assign(to: \.text, on: label)
    .store(in: &cancellables)
}

// It communicates that we want to map the Double that is provided by $kwhInBattery into a String, and that we want to assign that string to the text property on label. The assign(to:on:) method returns an AnyCancellable, just like sink. So we need to retain it to make sure it doesn't get deallocated.


// Using assign(to:on:) becomes very interesting if you use an architecture where your model prepares data for your view in a way where no further processing is required, like MVVM:
struct CarViewModel {
  private let car = Car()

  let chargeRemainingText: AnyPublisher<String?, Never>

  init() {
    chargeRemainingText = car.$kwhInBattery.map {
      "Car's charge is \($0)"
    }.eraseToAnyPublisher()
  }
}

class CarViewController2: UIViewController {
  let viewModel = CarViewModel()
  let label = UILabel()

  var cancellables = Set<AnyCancellable>()

    func subscribeToCarCharge() {
    viewModel.chargeRemainingText
        .assign(to: \.text, on: label)
        .store(in: &cancellables)
    }

  // More VC code...
}


// Avoiding retains cycles when using assign(to:on:)
// there are cases where assign(to:on:) might cause retain cycles.

var subscription: AnyCancellable?

func subscribeToCarCharge() {
  subscription = viewModel.chargeRemainingText
    .assign(to: \.label.text, on: self)
}
//The code above uses self as the target for the assignment, while self also holds on to the AnyCancellable that is returned by assign(to:on:). At this time there isn't much you can do other than implementing a workaround (https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546/8), or avoiding assignment to self
