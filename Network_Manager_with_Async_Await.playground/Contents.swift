// courtsey: https://medium.com/@B4k3R/creating-a-basic-network-manager-with-async-await-swift-networking-made-easy-40f4e3f317b6

import Foundation

// MARK: - Network Response
// Conform to Codable
public protocol NetworkResponse: Codable { }


// MARK: - Network Request
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

// MARK: - Network Error
public enum NetworkError: Error {
    case httpError(statusCode: Int)
    case decodingError(Error)
}

// MARK: - NetworkManager Class
public class NetworkManager {
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
}
