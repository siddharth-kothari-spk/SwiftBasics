// https://www.avanderlee.com/swift/existential-any/

// By using the any keyword in front of a protocol, we’re defining an existential type of a specific protocol.

import Foundation

protocol Content {
    var id: UUID { get }
    var url: URL { get }
}

struct ImageContent: Content {
    let id = UUID()
    let url: URL
}

let content: any Content = ImageContent(url: URL(string: "test")!)

// from swift 5.7 , we could redefine our Content protocol to inherit the Identifiable protocol with a UUID type constraint and use it as an existential accordingly:

protocol Content_5_7: Identifiable where ID == UUID {
    var url: URL { get }
}

struct ImageContent_5_7: Content_5_7 {
    let id = UUID()
    let url: URL
}

let content_5_7: any Content_5_7 = ImageContent_5_7(url: URL(string: "test")!)





