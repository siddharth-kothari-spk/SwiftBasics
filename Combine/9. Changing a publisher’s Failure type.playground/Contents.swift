/// courtsey: https://www.donnywals.com/changing-a-publishers-failure-type-in-combine/
///
import Combine
import Foundation
// In Combine, publishers have an Output type and a Failure type. The Output represents the values that a publisher can emit, the Failure represents the errors that a publisher can emit
// But what happens when you have a slightly more complicated setup? What happens if you want to transform a publisher's output into a new publisher but the errors of the old and new publishers don't line up?

// e.g. : write an extension on Publisher that would transform URLRequest values into URLSession.DataTaskPublisher values so each emitted URLRequest would automatically become a network request.
extension Publisher where Output == URLRequest {
  func performRequest() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    return self
      .flatMap({ request in
        return URLSession.shared.dataTaskPublisher(for: request)
      })
      .eraseToAnyPublisher() // error: Cannot convert return expression of type 'AnyPublisher<URLSession.DataTaskPublisher.Output, Self.Failure>' to return type 'AnyPublisher<(data: Data, response: URLResponse), any Error>'
  }
}

// we know that Publisher.Failure must conform to the Error protocol. This means that we can erase the error type completely, and transform it into a generic Error instead with Combine's mapError(_:)


extension Publisher where Output == URLRequest {
    func performRequest() -> AnyPublisher<(data: Data, response: URLResponse),Error> {
        return self.mapError({ (error: Self.Failure) -> Error in
            return error
        }).flatMap({request in
            return URLSession.shared.dataTaskPublisher(for: request).mapError({ (error: URLError) -> Error in
                return error
            })
        })
        .eraseToAnyPublisher()
    }
}
// apply mapError(_:) to self which is the source publisher and to the URLSession.DataTaskPublisher that's created in the flatMap. This way, both publishers emit a generic Error rather than their specialized error.

// An alternative to erasing the error completely could be to map any errors emitted by the source publisher to a failing URLRequest:
extension Publisher where Output == URLRequest {
    func performRequest_URLError() -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return self.mapError({ (error: Self.Failure) -> URLError in
            return URLError(.badURL)
        })
        .flatMap({ request in
            return URLSession.shared.dataTaskPublisher(for: request)
        })
        .eraseToAnyPublisher()
    }
}

// transform the output of any publisher into a generic Error:
extension Publisher {
  func genericError() -> AnyPublisher<Self.Output, Error> {
    return self
      .mapError({ (error: Self.Failure) -> Error in
        return error
      }).eraseToAnyPublisher()
  }
}

// using generic error method
extension Publisher where Output == URLRequest {
  func performRequest() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    return self
      .genericError()
      .flatMap({ request in
        return URLSession.shared.dataTaskPublisher(for: request)
          .genericError()
      })
      .eraseToAnyPublisher()
  }
}
