import Foundation
/// courtsey: https://www.donnywals.com/refactoring-a-networking-layer-to-use-combine/
///
// we're designing a networking API. The goal here is to abstract the networking layer in such a way that we can easily use, reuse and arguably most importantly, test all code we write

// protocols
protocol FeedProviding {
    var network: Networking { get }
    func getFeed(_ completion: @escaping (Result<Feed, Error>) -> Void)
}

enum Endpoint {
  case feed
}

// model
struct Feed: Codable {
    
}

class FeedViewModel {
  let service: FeedProviding
  var feed: Feed?
  var onFeedUpdate: () -> Void = {}

  init(service: FeedProviding) {
    self.service = service
  }

  func fetch() {
    service.getFeed { result in
      do {
        self.feed = try result.get()
        self.onFeedUpdate()
      } catch {
        // handle error
      }

    }
  }
}

// In Swift, it's possible to write extensions for protocols to give them default behaviors and functionality.
extension FeedProviding {
    func getFeed(_ completion: @escaping (Result<Feed, Error>) -> Void) {
        network.fetch(.feed, completion: completion)
      }
}
// why we should bother with this method and protocol at all. We might just as well either skip the service object and use a networking object directly in the view model. Or we could just call service.network.fetch(_:completion:) from the view model. The reason we need a service object in between the network and the view model is that we want the view model to be data source agnostic.

// based on the few lines of code in the extension we added to FeedProviding we now have three new goals:

// 1.The networking object should accept some kind of endpoint or request configuration object.
// 2.The networking object's fetch(_:completion:) should decode data into an appropriate model.
// 3.Any object that implements FeedProviding requires a networking object.

// for 1st 2 points
protocol Networking {
  func fetch<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

// By making fetch(_:completion:) generic over a Decodable object T, we achieve an extremely high level of flexibility. The service layer can define what the Networking object will decode its data into because Swift will infer T based on the completion closure that is passed to fetch(_:completion:).

//To implement the third requirement from the list above, all we need to do is add a network property to the FeedProviding protocol.

// sample implementation of fetch(_:completion)
extension Networking {
  func fetch<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
    let urlRequest = endpoint.urlRequest // i)

    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      do {
        if let error = error {
          completion(.failure(error))
          return
        }

        guard let data = data else {
          preconditionFailure("No error was received but we also don't have data...")
        }

        let decodedObject = try JSONDecoder().decode(T.self, from: data)

        completion(.success(decodedObject))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
}

// i) we ask the endpoint object for a URLRequest object. This is a good idea because by doing that, the endpoint can configure the request.
// We'll refactor the code in a minute so that the URLRequest configuration is abstracted behind a protocol and we don't rely on the enum anymore in the networking layer.


protocol RequestProviding {
  var urlRequest: URLRequest { get }
}

extension Endpoint: RequestProviding {
  var urlRequest: URLRequest {
    switch self {
    case .feed:
      guard let url = URL(string: "https://mydomain.com/feed") else {
        preconditionFailure("Invalid URL used to create URL instance")
      }

      return URLRequest(url: url)
    }
  }
}
