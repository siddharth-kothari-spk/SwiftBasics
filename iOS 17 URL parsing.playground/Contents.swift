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

// The new behavior is convenient for new projects because now you can combine your link with, for example, a search string and be calm that it works, even in cases with spaces and Cyrillic

// iOS 16
let validURLCyrilliciOS16 = URL(string: "https://google.com/клята русня") // -> nil

// iOS 17
let validURLCyrilliciOS17 = URL(string: "https://google.com/клята русня") // -> https://google.com/%D0%BA%D0%BB%D1%8F%D1%82%D0%B0%20%D1%80%D1%83%D1%81%D0%BD%D1%8F

// But if you have a code that checks URL for nil, now you can see unpredictable cases that break your logic in iOS 17
// This code works correctly in iOS 16, but in iOS 17 it sets every string as a URL.
func setupLabel(with text: String) {
    if let url = URL(string: text) {
        // make label tappable
    } else {
        // just setup a text
    }
}

// Apple updated the URL initializer for iOS 17 with a new Bool parameter encodingInvalidCharacters that has a default value (true) — it is what makes the behavior unpredictable. You can revert the old behavior and add false directly:


// iOS 17
let urliOS17encodingInvalidCharacters = URL(string: "Not an URL", encodingInvalidCharacters: false) // => nil
