// Created on 22/02/2020

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    typealias CallbackDefinition = () -> Void
    private let callback: CallbackDefinition
    
    init(callback: @escaping CallbackDefinition) {
        self.callback = callback
    }
    
    override func resume() {
        callback()
    }
    
    override func cancel() {
        // do nothing
    }
}

class MockURLSession: URLSession {
    var request: URLRequest?
    
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?
    
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        self.request = request
        return MockURLSessionDataTask(callback: { [weak self] in
            completionHandler(self?.data, self?.response, self?.error)
        })
    }
}
