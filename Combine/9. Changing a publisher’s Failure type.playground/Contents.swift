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


