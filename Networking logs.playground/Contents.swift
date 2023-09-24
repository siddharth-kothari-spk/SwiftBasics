// https://nitinagam.medium.com/networking-logs-in-swift-e0764e4ce0a1
import UIKit
import Foundation

extension URLRequest {
    
    func log() {
        let body = self.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "Nil"
        let requestUrl = self.url?.absoluteString ?? "Nil"
        
        var headerPrint = ""
#if DEBUG
        headerPrint = "-> HEADERS: \(String(describing: self.allHTTPHeaderFields))"
#endif
        
        let networkRequest = """
            ⚡️⚡️⚡️⚡️ REQUEST START ⚡️⚡️⚡️⚡️
            -> URL: \(requestUrl)
            -> METHOD: \(String(describing: self.httpMethod))
            -> BODY: \(body)
            \(headerPrint)
            ⚡️⚡️⚡️⚡️ REQUEST END ⚡️⚡️⚡️⚡️
        """
        print(networkRequest)
    }
}

extension URLResponse {
    
    func log(data: Data?, error: Error?, printJSON: Bool = false) {
        var statusCode = 0
        if let httpUrlResponse = self as? HTTPURLResponse {
            statusCode = httpUrlResponse.statusCode
        }
        
        let jsonToPrint = printJSON ? "-> DATA JSON: \(String(describing: data?.jsonObject))" : ""
        
        let networkResponse = """
        ⚡️⚡️⚡️⚡️ RESPONSE START ⚡️⚡️⚡️⚡️
        -> URL: \(self.url?.absoluteString ?? "nil")
        -> DATA: \(String(describing: data))
        -> STATUS CODE: \(statusCode)
        -> ERROR: \(String(describing: error))
        \(jsonToPrint)
        ⚡️⚡️⚡️⚡️ RESPONSE END ⚡️⚡️⚡️⚡️
    """
        print(networkResponse)
    }
}

extension Data {
    var jsonObject: Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        } catch {
            return nil
        }
    }
}

let url = URL(string: "https://api.example.com/endpoint")!
var request = URLRequest(url: url)
request.httpMethod = "GET"
request.log()

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    
    if let response = response {
        response.log(data: data, error: error, printJSON: true)
    }
    
    // handle response and data further here...
}

task.resume()
