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
    
    // The performRequest function is taking the request as a parameter & extrapolating the NetworkResponse from the generic parameter of the NetworkRequest. From there it’s getting the actual request data from the defined properties. Then it uses the async method session.data(for: URLRequest) to do the actual netowork call. Once it has the response information it can then either throw an error if necessary, or parse the data into the NetworkResponse object.
    
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


//MARK: - Defining a NetworkRequest
// Define the NetworkResponse
struct Country: NetworkResponse {
    let name: CountryName
    
    struct CountryName: Codable {
        let common: String
        let official: String
    }
}

// Define how the NetworkRequest is created
// Error 1 : No type for 'ResponseType' can satisfy both 'ResponseType == Array<Country>' and 'ResponseType : NetworkResponse'
extension NetworkRequest where ResponseType == [Country] {
    static func searchCountryByName(_ name: String) -> NetworkRequest<[Country]> {
        let urlString = "https://restcountries.com/v3.1/name/\(name)?fullText=true"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        
        return NetworkRequest<[Country]>(
            method: .get,
            url: url,
            headers: nil,
            body: nil
        )
    }
}


// Extend Array's where Element is NetworkResponse
// to add NetworkConformance to the actual Array object
    // This allows the Array to be used as the NetworkResponse in your generics
extension Array: NetworkResponse where Element : NetworkResponse { }
