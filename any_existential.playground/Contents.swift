// https://www.avanderlee.com/swift/existential-any/

// By using the any keyword in front of a protocol, we’re defining an existential type of a specific protocol.

import Foundation
import UIKit

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

// Constrained existentials
protocol ImageFetching<Image> {
    associatedtype Image
    func fetchImage() -> Image
}

/*
 The generic parameter in the protocol definition defines the primary associated type by matching the name of the associated type that has to become primary. In this case, we defined Image to be our primary associated type.

 We can use the primary associated type as a constraint in our code.
 */

extension UIImageView {
    func configureImage(with imageFetcher: any ImageFetching<UIImage>) {
        image = imageFetcher.fetchImage()
    }
}

/*
 Since UIImageView requires a UIImage type, we constrained the parameter type to be any kind of ImageFetching, but having an associated type of UIImage. In other words: we can use any type conforming to the ImageFetching protocol, but it has to define UIImage as its associated type.
 */

