/// courtsey: https://www.donnywals.com/using-map-flatmap-and-compactmap-in-combine/
import Combine

// basic publisher that outputs integers
let intPublisher = [1, 2, 3].publisher

// publisher using a CurrentValueSubject
let intSubject = CurrentValueSubject<Int, Never>(1)
intSubject.sink(receiveValue: { int in
  myLabel.text = "Number \(int)"
})

//  To be able to use the intSubject as a direct driver for myLabel.text we need to transform its output so it becomes a string. We can do this using map:
intSubject
    .map{ intValue in "Number: \(intValue)"}
    .assign(to: \.text, on: myLabel)
