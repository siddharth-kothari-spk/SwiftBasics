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

