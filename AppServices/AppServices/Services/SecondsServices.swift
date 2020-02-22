// Created on 22/02/2020

import Foundation

public class RequestManager {
    private let session = URLSession.shared
    private let timeout: TimeInterval = 60.0
    
    let route: RouterManagerConvertible
    let success: (Data) -> Void
    let fail: (Error?) -> Void
    
    public init(route: RouterManagerConvertible, success: @escaping (Data) -> Void, fail: @escaping (Error?) -> Void) {
        self.route = route
        self.success = success
        self.fail = fail
    }
    
    func send() {
        let request = buildRequest(routeManager: route.asRouter())
        session.dataTask(with: request) { [fail, success] (data, response, error) in
            guard let data = data else {
                fail(error)
                return
            }
            
            success(data)
        }.resume()
    }
}

extension RequestManager {
    private func buildRequest(routeManager: RouterManager) -> URLRequest {
        var request = URLRequest(url: routeManager.asURL(), cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        request.addValue(routeManager.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        request.httpMethod = routeManager.method.rawValue
        
        return request
    }
}
