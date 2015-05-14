//
//  PriorityQueueTests.m
//  CrazyCache
//
//  Created by chen on 5/11/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CWPriorityQueue.h"
#import "CWEntity.h"

@interface PriorityQueueTests : XCTestCase

@end

@implementation PriorityQueueTests

- (void)setUp {
    [super setUp];
    NSLog(@"----------Setting up tests for priority queue");
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
    NSLog(@"finished tests for priority queue");
}

- (void)testInitiate
{
    CWPriorityQueue* q = [[CWPriorityQueue alloc] initWithCapacity:10];
    XCTAssert(q!=nil);
    XCTAssert(q.size == 0);
}

- (void)testAddTwoElements
{
    NSLog(@"----testing add elements-----");
    CWPriorityQueue* q =[[CWPriorityQueue alloc] initWithCapacity:10];
    /*
     NOTE!!! here dispatch_semaphore_create() should contain 0 as initial param
     Otherwise using 2 would cause semaphore not waiting!
     */
    
//    q.semaphore=dispatch_semaphore_create(0);
//    XCTAssert(q!=nil);
//    CWEntity* entity =[[CWEntity alloc] initWithItem:@"1" andId:@"1"];
//    entity.avgScore=[NSNumber numberWithInteger:1];
//    [q addEntity:entity];
////    dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, DISPATCH_TIME_FOREVER);
//    if (dispatch_semaphore_wait(q.semaphore, DISPATCH_TIME_FOREVER)) {
//        XCTFail(@" timed out");
//    }
//    
//    XCTAssert([@"1" isEqualToString:((CWEntity*)[q.getQueue objectAtIndex:0]).item]);
//    
//    CWEntity* newEntity = [[CWEntity alloc] initWithItem:@"0" andId:@"0"];
//    newEntity.avgScore=[NSNumber numberWithInteger:0];
//    [q addEntity:newEntity];
//    
//    if (dispatch_semaphore_wait(q.semaphore, DISPATCH_TIME_FOREVER)) {
//        XCTFail(@" timed out");
//    }
//    
//    XCTAssert(([((CWEntity*)[q.getQueue objectAtIndex:0]).item isEqualToString:@"0"]) && ([((CWEntity*)[q.getQueue objectAtIndex:1]).item isEqualToString:@"1"]));
    
}

- (void)testAddMultipleElements
{
    

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
