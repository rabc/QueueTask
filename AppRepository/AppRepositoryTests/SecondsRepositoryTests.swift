// Created on 22/02/2020

import XCTest
@testable import AppRepository

class SecondsRepositoryTests: XCTestCase {
    
    let userDefaults = UserDefaultsManager()
    
    override func setUp() {
        userDefaults.remove(.hour)
    }

    func testSendTime() {
        let date = Date()
        
        let exp = expectation(description: "waitCallback")
        
        let repository = SecondsRepository()
        repository.sendTime(date) { (_) in
            let dates: [HourData] = self.userDefaults.get(.hour) ?? []
            XCTAssertTrue(dates.first?.sent ?? false)
            exp.fulfill()
        }
        
        XCTAssertEqual(repository.queue.operations.count, 1)
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testSendSameTime() {
        let date = Date()
                
        let repository = SecondsRepository()
        repository.sendTime(date) { (_) in
            
        }
        
        repository.sendTime(date) { (_) in
            
        }
        
        XCTAssertEqual(repository.queue.operations.count, 1)
    }
    
    func testFlush() {
        userDefaults.set([HourData(seconds: "1", hour: "2")], for: .hour)
        let repository = SecondsRepository()
        repository.flush()
        XCTAssertEqual(repository.queue.operations.count, 1)
    }

}
