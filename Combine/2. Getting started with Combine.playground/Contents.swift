/// courtsey: https://www.donnywals.com/an-introduction-to-combine/
///
import Combine

// 1. Subscribing to a simple publisher
[1,2,3]
    .publisher // i)
    .sink(receiveCompletion: { // ii)
        completion in
        switch completion {
        case .failure(let error):
            print("error: \(error)")
        case .finished:
            print("completion received")
        }
    }, receiveValue: { value in // iii)
        print("received value: \(value)")
    })

/// i) The Combine framework adds a publisher property to Array. We can use this property to turn an array of values into a publisher that will publish all values in the array to the subscribers of the publisher.
///  The type of the created publisher is Publishers.Sequence<[Int], Never>
/// all the built-in publishers in the Combine framework are grouped under the Publishers enum. Each of the publishers that exist in this namespace conforms to the Publisher protocol
/// Every publisher in Combine has an Output and a Failure type. The Output is the type of value that a publisher will push to its subscribers. In the case of our Sequence, the Output will be Int. The Failure type is Never because the publisher cannot finish with an error.
///
///
///  ii) You can subscribe to a publisher using the sink(receiveCompletion:receiveValue:) method. This method creates a subscriber that is subscribed to the publisher that the method was called on.
///
///
///  iii) The receiveValue closure is called whenever a new value is published by the publisher. This closure receives the latest value of the publisher as its single argument



