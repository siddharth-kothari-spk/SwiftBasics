import Foundation
import Combine

/// courtsey: https://www.donnywals.com/refactoring-a-networking-layer-to-use-combine/
///
///
// PART 1: https://www.donnywals.com/architecting-a-robust-networking-layer-with-protocols/
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
        network.execute(Endpoint.feed, completion: completion)
      }
}
// why we should bother with this method and protocol at all. We might just as well either skip the service object and use a networking object directly in the view model. Or we could just call service.network.fetch(_:completion:) from the view model. The reason we need a service object in between the network and the view model is that we want the view model to be data source agnostic.

// based on the few lines of code in the extension we added to FeedProviding we now have three new goals:

// 1.The networking object should accept some kind of endpoint or request configuration object.
// 2.The networking object's fetch(_:completion:) should decode data into an appropriate model.
// 3.Any object that implements FeedProviding requires a networking object.

// for 1st 2 points
protocol Networking {
    // renamed the fetch(_:completion:) method to execute(_:completion:). The reason for this is that we don't know whether the network call that's made is going to be a GET or POST.
    func execute<T: Decodable>(_ requestProvider: RequestProviding, completion: @escaping (Result<T, Error>) -> Void)
}

// By making fetch(_:completion:) generic over a Decodable object T, we achieve an extremely high level of flexibility. The service layer can define what the Networking object will decode its data into because Swift will infer T based on the completion closure that is passed to fetch(_:completion:).

//To implement the third requirement from the list above, all we need to do is add a network property to the FeedProviding protocol.

// sample implementation of fetch(_:completion)
extension Networking {
    func execute<T: Decodable>(_ requestProvider: RequestProviding, completion: @escaping (Result<T, Error>) -> Void) {
        let urlRequest = requestProvider.urlRequest // i)

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

// PART 2: to change to combine
struct PhotoFeed: Codable {
    
}

protocol APISessionProviding {
  func execute<T: Decodable>(_ requestProvider: RequestProviding) -> AnyPublisher<T, Error>
}

protocol PhotoFeedProviding {
  var apiSession: APISessionProviding { get }

  func getPhotoFeed() -> AnyPublisher<PhotoFeed, Never>
}

//  it's important to understand that AnyPublisher is a generic, type erased, version of a Publisher that behaves just like a regular Publisher while hiding what kind of publisher it is exactly.

// making network call
struct ApiSession: APISessionProviding {
    func execute<T>(_ requestProvider: RequestProviding) -> AnyPublisher<T, Error> where T: Decodable {
        return URLSession.shared.dataTaskPublisher(for: requestProvider.urlRequest)
        // error : Cannot convert return expression of type 'URLSession.DataTaskPublisher' to return type 'AnyPublisher<T, any Error>'
        // we need to somehow convert that publisher into another publisher so we can eventually return AnyPublisher<T, Error>
            .map {$0.data}
            .decode(type: T.self, decoder: JSONDecoder())
        // The code above takes the Output of the URLSession.DataTaskPublisher which is (data: Data, response: URLResponse) and transforms that into a publisher whose Output is Data using the map operator. The resulting publisher is then transformed again using the decode(type:decoder:) operator so we end up with a publisher who's output is equal to T.
        // error: Cannot convert return expression of type 'Publishers.Decode<Publishers.Map<URLSession.DataTaskPublisher, JSONDecoder.Input>, T, JSONDecoder>' (aka 'Publishers.Decode<Publishers.Map<URLSession.DataTaskPublisher, Data>, T, JSONDecoder>') to return type 'AnyPublisher<T, any Error>'
            .eraseToAnyPublisher()
        // The code above does not handle any errors. If an error occurs at any point in this chain of publishers, the error is immediately forwarded to the object that subscribes to the publisher that's returned by execute(_:)
    }
}
// The execute method returns a publisher so that other objects can subscribe to this publisher, and can handle the result of the network call.

// handling error
enum FeedService {
    case photoFeed
}

extension FeedService: RequestProviding {
  var urlRequest: URLRequest {
    switch self {
    case .photoFeed:
      guard let url = URL(string: "https://mydomain.com/feed") else {
        preconditionFailure("Invalid URL used to create URL instance")
      }

      return URLRequest(url: url)
    }
  }
}

struct PhotoFeedProvider: PhotoFeedProviding {
  let apiSession: APISessionProviding

  func getPhotoFeed() -> AnyPublisher<PhotoFeed, Never> {
    return apiSession.execute(FeedService.photoFeed)
      .catch { error in
        return Just(PhotoFeed())
      }.eraseToAnyPublisher()
  }
}

//
