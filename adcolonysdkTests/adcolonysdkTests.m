//
//  adcolonysdkTests.m
//  adcolonysdkTests
//
//  Created by Anatoly Macarov on 4/4/16.
//  Copyright © 2016 Opera. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "adcolonysdk.h"

@interface adcolonysdkTests : XCTestCase

@end

@implementation adcolonysdkTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"All posts"];
    
    [[ACRequestManager sharedInstance] fetchAllPostsWithCompletionHandler:^(NSArray *posts, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(posts);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
    expectation = [self expectationWithDescription:@"posts for User 1"];
    
    [[ACRequestManager sharedInstance] fetchPostsForUserId:@"1" WithCompletionHandler:^(NSArray *posts, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(posts);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

@end
