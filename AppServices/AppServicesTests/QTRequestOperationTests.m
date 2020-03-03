// Created on 03/03/2020

#import <XCTest/XCTest.h>
#import <AppServices/AppServices.h>
@import OHHTTPStubs;

@interface QTRequestOperationTests : XCTestCase

@end

@implementation QTRequestOperationTests

- (void)testOperation {
    NSString *seconds = @"01";
    NSString *name = @"MyName";
    
    NSString *testString = @"TestData";
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return [request.URL.host isEqualToString:@"jsonplaceholder.typicode.com"];
    } withStubResponse:^HTTPStubsResponse*(NSURLRequest *request) {
        return [HTTPStubsResponse responseWithData:[testString dataUsingEncoding:NSUTF8StringEncoding]
                                        statusCode:200
                                           headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"waitCallback"];
    
    QTRequestOperation *operation = [[QTRequestOperation alloc] initWithName:name
                                                                     seconds:seconds
                                                                     success:^(NSData *data) {
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        XCTAssertTrue([response isEqualToString:testString]);
        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Should not return error");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

@end
