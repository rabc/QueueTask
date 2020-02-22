// Created on 22/02/2020

import Foundation

/// All the HTTP methods in use
///
/// - get: GET
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ContentType: String {
    case json = "application/json"
}

public struct RouterManager {
    let endpoint: String
    let method: HTTPMethod
    let contentType: ContentType
    
    let host: String = "https://jsonplaceholder.typicode.com"
    
    /// Init
    ///
    /// - Parameters:
    ///   - endpoint:
    ///   - method:
    ///   - contentType: Default to `json`
    init(endpoint: String, method: HTTPMethod, contentType: ContentType = .json) {
        self.endpoint = endpoint
        self.method = method
        self.contentType = contentType
    }
    
    /// Convert the current endpoint to the APIs full URL
    ///
    ///
    /// - Returns: URL
    func asURL() -> URL {
        guard var url = URL(string: host) else {
            assert(false, "Something wrong with the host \(host)")
        }
        
        url.appendPathComponent(endpoint)
        
        return url
    }
}
