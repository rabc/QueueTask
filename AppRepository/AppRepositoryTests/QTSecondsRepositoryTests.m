// Created on 03/03/2020

#import <XCTest/XCTest.h>
#import <AppRepository/AppRepository.h>

@interface QTSecondsRepositoryTests : XCTestCase

@end

@implementation QTSecondsRepositoryTests

- (void)setUp {
    [NSUserDefaults.standardUserDefaults removeObjectForKey:@"hour"];
}

- (void)testSendTime {
    NSDate *date = [NSDate date];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"waitCallback"];
    
    QTSecondsRepository *repository = [[QTSecondsRepository alloc] init];
    [repository sendDate:date callback:^(QTSeconds *seconds) {
        XCTAssertNotNil([NSUserDefaults.standardUserDefaults objectForKey:@"hour"]);
        [expectation fulfill];
    }];
    
    XCTAssertEqual(repository.queue.operations.count, 1);
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testSendSameTime {
    NSDate *date = [NSDate date];
    
    QTSecondsRepository *repository = [[QTSecondsRepository alloc] init];
    
    [repository sendDate:date callback:^(QTSeconds *seconds) {
        
    }];
    
    [repository sendDate:date callback:^(QTSeconds *seconds) {
        
    }];
    
    XCTAssertEqual(repository.queue.operations.count, 1);
}

@end
