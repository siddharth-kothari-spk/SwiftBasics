import UIKit

// courtsey: https://www.donnywals.com/what-are-sendable-and-sendable-closures-in-swift/

/// Sendable address a challenging problem of type-checking values passed between structured concurrency constructs and actor messages.

// Value types like structs and enums are Sendable by default as long as all of their members are also Sendable.
struct MovieSendable {
    var formattedReleaseDate = "2022"
}

//The struct only holds Sendable state. String is Sendable and since it’s the only property defined on MovieSendable, movie is also Sendable.

// This struct is not sendable

class FormatterCache {
    var formatters = [String: DateFormatter]()

    func formatter(for format: String) -> DateFormatter {
        if let formatter = formatters[format] {
            return formatter
        }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatters[format] = formatter

        return formatter
    }
}

struct MovieNotSendable {
    let formatterCache = FormatterCache()
    let releaseDate = Date()
    var formattedReleaseDate: String {
        let formatter = formatterCache.formatter(for: "YYYY")
        return formatter.string(from: releaseDate)
    }
}

// The point is that the struct does not really hold mutable state; all of its properties are either constants, or they are computed properties. However, FormatterCache is a class that isn't Sendable. Since our MovieNotSendable struct doesn’t hold a copy of the FormatterCache but a reference, all copies of MovieNotSendable would be looking at the same instances of the FormatterCache, which means that we might be looking at data races if multiple MovieNotSendable copies would attempt to, for example, interact with the formatterCache.
// To make it sendable we need to do the following

struct MovieNotSendableToSendable: Sendable {
    let formatterCache = FormatterCache()
    // warning: Stored property 'formatterCache' of 'Sendable'-conforming struct 'MovieNotSendableToSendable' has non-sendable type 'FormatterCache'
    let releaseDate = Date()
    var formattedReleaseDate: String {
        let formatter = formatterCache.formatter(for: "YYYY")
        return formatter.string(from: releaseDate)
    }
}

