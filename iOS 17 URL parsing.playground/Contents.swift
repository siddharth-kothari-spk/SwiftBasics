// courtsey: https://ihor.pro/handling-a-new-url-parsing-behavior-in-ios-17-c08598d28659

import UIKit
import Foundation

// For apps linked on or after iOS 17 and aligned OS versions, URL parsing has updated from the obsolete RFC 1738/1808 parsing to the same RFC 3986 parsing as URLComponents. This unifies the parsing behaviors of the URL and URLComponents APIs. Now, URL automatically percent- and IDNA-encodes invalid characters to help create a valid URL.

// iOS 16
let validURLiOS16 = URL(string: "https://google.com") // -> https://google.com
let urliOS16 = URL(string: "Not an URL")              // -> nil

// iOS 17
let validURLiOS17 = URL(string: "https://google.com") // -> https://google.com
let urliOS17 = URL(string: "Not an URL")              // -> Not%an%URL


