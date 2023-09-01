/// courtsey: https://gist.github.com/donnywals/83985376d4f83842d505e2868c3498c3
/// 
import Foundation
import Combine

enum DataTaskError: Error {
  case rateLimit(UUID)
  case serverBusy(UUID)
  case invalidResponse
}

// a sample failure JSON
let errorJSON = """
  {
    "error": "rateLimit"
  }
  """.data(using: .utf8)!

let dataTaskPublisher: AnyPublisher<(data: Data, response: URLResponse), Error> = Deferred {
  Future { promise in
    print("Network call \(UUID())")
    
    // mock a 429 server response with the `errorJSON` as a response body
    let httpResponse = HTTPURLResponse(url: URL(string: "https://bogus.com")!, statusCode: 429,
                                       httpVersion: nil, headerFields: nil)!

    promise(.success((data: errorJSON, response: httpResponse)))
  }
}.eraseToAnyPublisher()

var cancellables = Set<AnyCancellable>()

// Because I don't like typing long stuff
typealias DataTaskOutput = URLSession.DataTaskPublisher.Output
typealias DataTaskResult = Result<DataTaskOutput, Error>

dataTaskPublisher
  // analyze the response to ensure we have a response that we want to try
  // I transform output -> Result so we can work around the tryCatch later if we encountered a non-retryable error
  .tryMap({ (dataTaskOutput: DataTaskOutput) -> DataTaskResult in
    // infamous "should never happen" situation
    guard let response = dataTaskOutput.response as? HTTPURLResponse else {
      throw DataTaskError.invalidResponse
    }

    // we want to retry a rate limit error
    if response.statusCode == 429 {
      throw DataTaskError.rateLimit(UUID())
    }

    // we don't want to retry anything else
    return .success(dataTaskOutput)
  })
  // catch any errors
  .catch({ (error: Error) -> AnyPublisher<DataTaskResult, Error> in
    switch error {
    case DataTaskError.rateLimit(let uuid):
      print("caught error: \(uuid)")
      // return a Fail publisher that fails after 3 seconds, this means the `retry` will fire after 3s
      return Fail(error: error)
        .delay(for: 3, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    default:
      // We encountered a non-retryable error, wrap in Result so the publisher succeeds and we'll extract the error later
      return Just(.failure(error))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
  })
  .retry(2)
  .tryMap({ result in
    // Result -> Result.Success or emit Result.Failure
    return try result.get()
  })
  .sink(receiveCompletion: { completion in
    print(completion)
  }, receiveValue: { value in
    print(value)
  })
  .store(in: &cancellables)
