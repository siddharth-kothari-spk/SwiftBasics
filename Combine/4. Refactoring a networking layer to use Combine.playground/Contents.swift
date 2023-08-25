/// courtsey: https://www.donnywals.com/refactoring-a-networking-layer-to-use-combine/
///
// we're designing a networking API. The goal here is to abstract the networking layer in such a way that we can easily use, reuse and arguably most importantly, test all code we write

// protocols
protocol FeedProviding {
    
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

