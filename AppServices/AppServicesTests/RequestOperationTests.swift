// Created on 22/02/2020

import XCTest
@testable import AppServices

struct FakeRoute: RouterManagerConvertible {
    func asRouter() -> RouterManager {
        return RouterManager(endpoint: "", method: .get)
    }
}

class RequestOperationTests: XCTestCase {

    func testOperation() {
        let route = FakeRoute()
        let fakeData = "TestData".data(using: .utf8)
        
        let exp = expectation(description: "waitCallback")
        
        let session = MockURLSession()
        session.data = fakeData
        session.response = HTTPURLResponse(url: route.asRouter().asURL(),
                                           statusCode: 200,
                                           httpVersion: nil, headerFields: nil)
        
        let request = SecondsRequest(seconds: "1")
        let operation = RequestOperation(name: "", route: route, requestModel: request,
                                         success: { (data) in
                                            
                                            XCTAssertEqual(session.request?.url, route.asRouter().asURL())
                                            XCTAssertEqual(data, fakeData)
                                            exp.fulfill()
        }) { (error) in
            XCTFail("Should not return error")
            exp.fulfill()
        }
        
        operation.session = session
        
        let queue = OperationQueue()
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
        }
    }

}
