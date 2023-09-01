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

// Implementing a delayed retry
//Since retry doesn't allow us to specify a delay we'll need to come up with a clever solution.
//Use a catch to capture any errors, and return the initial publisher with a delay from the catch. Then place a retry after the catch operator.

dataTaskPublisher
  .tryCatch({ error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
    print("In the tryCatch")

    switch error {
    case DataTaskError.rateLimitted, DataTaskError.serverBusy:
      return dataTaskPublisher
        .delay(for: 3, scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    default:
      throw error
    }
  })
  .retry(2)
  .sink(receiveCompletion: { completion in
    print(completion)
  }, receiveValue: { value in
    print(value)
  })
  .store(in: &cancellables)

// use a tryCatch to inspect any errors coming from the data task publisher. If the error matches one of the errors where I want to perform a delayed retry, I return the dataTaskPublisher with a delay applied to it. This will delay the delivery of values from the data task publisher that I return from tryCatch



//An incorrect approach to a delayed retry - using share()
dataTaskPublisher.share()
  .tryCatch({ error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
    print("In the tryCatch")
    switch error {
    case DataTaskError.rateLimitted, DataTaskError.serverBusy:
      return dataTaskPublisher
        .delay(for: 3, scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    default:
      throw error
    }
  })
  .retry(2)
  .sink(receiveCompletion: { completion in
    print(completion)
  }, receiveValue: { value in
    print(value)
  })
  .store(in: &cancellables)

//By applying share() to the dataTaskPublisher a new publisher is created that will execute when it receives its initial subscriber and replays its results for any subsequent subscribers.

// issues with share()
//we use a shared publisher as the initial publisher, it will no longer execute its data task and the tryMap that we defined on the dataTaskPublisher earlier is no longer called. The result of the tryMap is cached in the share() and this cached result is immediately emitted when retry resubscribes. This means that share() will re-emit whatever error we received the first time it made its request.
//The retry operator in Combine will catch any errors that occur upstream and resubscribe to the pipeline so far. This means that any errors that occur above the retry will make it so we resubsribe to dataTaskPublisher.share(). In other words, the tryCatch that we have after dataTaskPublisher.share() will always receive the same error. So if the initial request failed due to being rate limitted and our retried request fails because we couldn't make a request, the tryCatch will still think we ran into a rate limit error and retry the request even though the logic in the tryCatch says we want to throw an error if we encountered something other than DataTaskError.rateLimitted or DataTaskError.serverBusy.


// Problems to fix
//1. We always receive the current / latest error in the tryCatch.
//2. We don't retry when we caught a non-retryable error.


//This means that we should get rid of the share() and actually run the network request when the retry resubscribes to dataTaskPublisher while making sure we don't get the extra requests that we wanted to get rid of in the previous section.

