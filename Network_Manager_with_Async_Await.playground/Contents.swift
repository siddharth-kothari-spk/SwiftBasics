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
    
    func performRequest<ResponseType: NetworkResponse>(_ request: NetworkRequest<ResponseType>) async throws -> ResponseType {
            // Create the URL object
            var urlRequest = URLRequest(url: request.url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.httpBody = request.body
            
            // Fetch the data from the server
            let (data, response) = try await session.data(for: urlRequest)
            
            // Check to make sure the httpResponse code is not outside of the 200...299 range
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                // If it is throw an error
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }
            
            // Try to decode your JSON response into your ResponseType object
            do {
                let decodedResponse = try JSONDecoder().decode(ResponseType.self, from: data)
                // Return your object
                return decodedResponse
            } catch {
                print(error)
                // Throw if error during decoding
                throw NetworkError.decodingError(error)
            }
        }
}
