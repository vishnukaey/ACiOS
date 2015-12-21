//
//  LegacyConnectTests.m
//  LegacyConnectTests
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface LegacyConnectTests : XCTestCase

@end

@implementation LegacyConnectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginAPI
{
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[@"prabhal+545@qburst.com",@"burst"] forKeys:@[kEmailKey, kPasswordKey]];
  [LCOnboardingAPIManager performLoginForUser:dict withSuccess:^(id response) {
    NSLog(@"passed is passed")
    ;    XCTAssert(YES, @"login Pass");
  } andFailure:^(NSString *error) {
    XCTFail(@"Fail");
  }];
}



@end
