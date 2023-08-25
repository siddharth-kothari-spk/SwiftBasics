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
