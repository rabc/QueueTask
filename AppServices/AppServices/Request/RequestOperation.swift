// Created on 22/02/2020

import Foundation

public enum EndpointsRouter: RouterManagerConvertible {
    case seconds
    
    public func asRouter() -> RouterManager {
        let endpoint = "/posts"
        return RouterManager(endpoint: endpoint, method: .post)
    }
}

public protocol RouterManagerConvertible {
    func asRouter() -> RouterManager
}

public enum RequestOperationError: Error {
    case encodeError
}

public class RequestOperation: Operation {
    private let timeout: TimeInterval = 60.0
    internal var session = URLSession.shared
    
    let route: RouterManagerConvertible
    let requestModel: SecondsRequest
    let success: (Data) -> Void
    let fail: (Error?) -> Void
    
    public required init(name: String, route: RouterManagerConvertible, requestModel: SecondsRequest,
                         success: @escaping (Data) -> Void, fail: @escaping (Error?) -> Void) {
        self.route = route
        self.requestModel = requestModel
        self.success = success
        self.fail = fail
        
        super.init()
        self.name = name
    }
    
    public override func main() {
        let request: URLRequest
        do {
            let data = try JSONEncoder().encode(requestModel)
            request = buildRequest(body: data, routeManager: route.asRouter())
        } catch {
            fail(RequestOperationError.encodeError)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        session.dataTask(with: request) { [fail, success] (data, response, error) in
            defer { semaphore.signal() }
            
            /* Uncomment the line below to simulate a (big) delay */
            //sleep(2)
            
            guard let data = data else {
                fail(error)
                return
            }
            
            success(data)
        }.resume()
        
        semaphore.wait()
    }
}

extension RequestOperation {
    private func buildRequest(body: Data, routeManager: RouterManager) -> URLRequest {
        var request = URLRequest(url: routeManager.asURL(), cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        request.addValue(routeManager.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        request.httpMethod = routeManager.method.rawValue
        request.httpBody = body
        
        return request
    }
}
