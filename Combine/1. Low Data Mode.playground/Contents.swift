/// courtsey: https://www.donnywals.com/supporting-low-data-mode-in-your-app/
/// with iOS 13, Apple announced a new feature called Low Data Mode. This feature allows users to limit the amount of data that’s used by apps on their phone.
///  With Low Data Mode, users can now inform your app that they are on such a network so you can accommodate their needs accordingly.
///  https://developer.apple.com/videos/play/wwdc2019/712/
///  Advances in Networking, Part 1
///
import Combine
import Foundation
import UIKit


enum TestEror: Error {
    case invalidUrl
}
// 1. configure low data mode support separately for each request

guard let url = URL(string: "someUrlString") else {
    throw TestEror.invalidUrl
}

var request = URLRequest(url: url)
request.allowsConstrainedNetworkAccess = false

// When you attempt to execute this URLRequest while Low Data Mode is active, it will fail with a URLError that has its networkUnavailableReason property set to .constrained.
// So whenever your request fails with that error, you might want to request a resource that consumes less data if needed, like a lower quality image

URLSession.shared.dataTask(with: request) {data, response, error in
    if let error = error {
        if let networkError = error as? URLError, networkError.networkUnavailableReason == .constrained {
          // make a new request for a smaller image
            downloadConstrainedAsset()
            return
        }

        // The request failed for some other reason
        return
      }

      if let data = data, let image = UIImage(data: data) {
        // image loaded succesfully
        return
      }
      // error: couldn't convert the data to an image
}

func downloadConstrainedAsset() {
    
}

// 2. Using Combine

enum NetworkError: Error {
    case invalidData
}

func fetchImage(largeUrl: URL, smallUrl: URL) -> AnyPublisher<UIImage, Error> {
  var request = URLRequest(url: largeUrl)
  request.allowsConstrainedNetworkAccess = false

  return URLSession.shared.dataTaskPublisher(for: request)
    .tryCatch { error -> URLSession.DataTaskPublisher in
      guard error.networkUnavailableReason == .constrained else {
        throw error
      }
      //  make a new request for a smaller image
      return URLSession.shared.dataTaskPublisher(for: smallUrl)
  }.tryMap { (data, _) -> UIImage in
    guard let image = UIImage(data: data) else {
      throw NetworkError.invalidData
    }

    return image
    }.eraseToAnyPublisher()
}

// 3. Enabling low data mode for an entire URLSession
var configuration = URLSessionConfiguration.default
configuration.allowsConstrainedNetworkAccess = false
let session = URLSession(configuration: configuration)

// 4. Low data mode for media playback
guard let mediaUrl = URL(string: "https://yourdomain.com/media.mp4")
  else { return }

let asset = AVURLAsset(url: mediaUrl, options: [AVURLAssetAllowsConstrainedNetworkAccessKey: false])

// 5. Detecting Low Data mode without relying on an error
// If you want to be pro-active with your low data mode implementation, and for instance warn a user that they are about to engage in an activity that will potentially use more data than they would like, you can use the Network framework. Apple's Network framework is typically used if you want to perform very low-level networking management that you can't achieve with URLSession. Since URLSession doesn't appear to have any way to detect whether a user has low data mode turned on before making a request, you must fall back to Network to do this kind of detection
let monitor = NWPathMonitor()

monitor.pathUpdateHandler = { path in
  let constrained = path.isConstrained
}

monitor.start(queue: DispatchQueue.global())

