/// courtsey: https://www.donnywals.com/supporting-low-data-mode-in-your-app/
/// with iOS 13, Apple announced a new feature called Low Data Mode. This feature allows users to limit the amount of data that’s used by apps on their phone.
///  With Low Data Mode, users can now inform your app that they are on such a network so you can accommodate their needs accordingly.
///  https://developer.apple.com/videos/play/wwdc2019/712/
///  Advances in Networking, Part 1
///
import Combine
import Foundation


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


