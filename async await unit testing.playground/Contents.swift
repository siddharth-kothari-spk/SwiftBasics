/// courtsey: https://www.avanderlee.com/concurrency/unit-testing-async-await/

import UIKit
import Foundation
import XCTest


enum Error: Swift.Error {
    case imageCastingFailed
    case invalidURL
}

struct ImageFetcher {
    func fetchImage(for url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw Error.imageCastingFailed
        }
        return image
    }
}

final class ImageFetcherTests: XCTest {
    func testImageFetching() async throws{
        let imageFetcher = ImageFetcher()
        
        guard let imageURL = URL(string: "https://picsum.photos/200/300") else {
            throw Error.invalidURL
        }
        let image = try await imageFetcher.fetchImage(for: imageURL)
        XCTAssertNotNil(image)
    }
}
