/// courtsey: https://www.donnywals.com/refactoring-a-networking-layer-to-use-combine/
///
// we're designing a networking API. The goal here is to abstract the networking layer in such a way that we can easily use, reuse and arguably most importantly, test all code we write

// protocols
protocol FeedProviding {
    func getFeed(_ completion: @escaping (Result<Feed, Error>) -> Void)
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
