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


// how should an HTTP status code of 429 (Too Many Requests / Rate Limit) or 503 (Server Busy) be handled? These will be seen as successful outcomes by Combine so we'll need to inspect the server's response, raise an error and retry the request with a couple of seconds delay since we don't want to make the server even busier than it already is (or continue hitting our rate limit).

enum DataTaskError: Error {
  case invalidResponse, rateLimitted, serverBusy
}

let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
  .tryMap({ response -> (data: Data, response: URLResponse) in
    // just so we can debug later in the post
    print("Received a response, checking status code")

    guard let httpResponse = response.response as? HTTPURLResponse else {
      throw DataTaskError.invalidResponse
    }

    if httpResponse.statusCode == 429 {
      throw DataTaskError.rateLimitted
    }

    if httpResponse.statusCode == 503 {
      throw DataTaskError.serverBusy
    }

    return response
  })


