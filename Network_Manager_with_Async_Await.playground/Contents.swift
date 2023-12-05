// courtsey: https://medium.com/@B4k3R/creating-a-basic-network-manager-with-async-await-swift-networking-made-easy-40f4e3f317b6

import Foundation

// Network Response
// Conform to Codable
public protocol NetworkResponse: Codable { }


// Network Request
public struct NetworkRequest<ResponseType: NetworkResponse> {
    let method: HTTPMethod
    let url: URL
    var headers: [String: String]?
    var body: Data?
}

public extension NetworkRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}


