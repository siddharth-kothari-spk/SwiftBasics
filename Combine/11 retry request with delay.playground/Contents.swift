/// courtsey: https://www.donnywals.com/retrying-a-network-request-with-a-delay-in-combine/
///
import Combine

// Combine comes with a handy retry operator that allows developers to retry an operation that failed. This is most typically used to retry a failed network request. As soon as the network request fails, the retry operator will resubscribe to the DataTaskPublisher, kicking off a new request hoping that the request will succeed this time.

// 1. Simple retry
var cancellables = Set<AnyCancellable>()

let url = URL(string: "https://practicalcombine.com")!
let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)

dataTaskPublisher
  .retry(3)
  .sink(receiveCompletion: { completion in
    // handle errors and completion
  }, receiveValue: { response in
    // handle response
  })
  .store(in: &cancellables)

// This code will fire a network request, and if the request fails it will be retried three times. That means that at most we'd make this request 4 times in total (once for the initial request and then three more times for the retries).

// Note that a 404, 501 or any other error status code does not count as a failed request in Combine. The request made it to the server and the server responded. A failed request typically means that the request wasn't executed because the device making the request is offline, the server failed to respond in a timely manner, or any other reason where we never received a response from the server.


