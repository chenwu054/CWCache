//
//  CWEntityTests.m
//  CWCache
//
//  Created by chen on 5/17/15.
//  Copyright (c) 2015 wu.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CWEntity.h"
#import "CWImage.h"

@interface CWEntityTests : XCTestCase

@end

@implementation CWEntityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreatingEntity
{
    CWEntity* entity = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"112"];
    entity.properties[@"imageContent"]=@"IMAGE_CONTENT";
    entity.properties[@"imageInitDate"]=[NSDate date];
    entity.properties[@"imageId"] = @"IMAGE_ID";
    NSLog(@"%@",entity);
    XCTAssert(entity);
}



- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
