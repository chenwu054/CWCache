//
//  CWCacheTests.m
//  CWCacheTests
//
//  Created by chen on 5/14/15.
//  Copyright (c) 2015 wu.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CWCache.h"
#import "CWImage.h"
#import "CWEntity.h"
#import "CWCacheLFUScheme.h"
#import "CWCacheLRUScheme.h"
#import "CWCacheRandomScheme.h"
#import "CWUtils.h"


@interface CWCacheTests : XCTestCase

@end

@implementation CWCacheTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testCreatingCache
{
    
//    NSDictionary* schemes = @{[[CWCacheLFUScheme alloc] init]:[NSNumber numberWithDouble:0.4],[[CWCacheLRUScheme alloc] init] : [NSNumber numberWithDouble:0.4]};
    NSArray* scheme = @[[[CWCacheLRUScheme alloc] init],[[CWCacheLFUScheme alloc] init],[[CWCacheRandomScheme alloc] init]];
    NSArray* ratio = @[[NSNumber numberWithDouble:5.0],[NSNumber numberWithDouble:3.0],[NSNumber numberWithDouble:2.0]];
//    
//    CWCache* cacheOne = [[CWCache alloc] initWithPriority:low andSchemes:schemes forClass:[CWImage class]];
    CWCache* cacheTwo = [[CWCache alloc] initWithPriority:high andSchemes:scheme withScoreRatio:ratio forClass:[CWImage class]];
//    CWCache* cacheThree = [[CWCache alloc] initWithPriority:nil andSchemes:schemes forClass:[CWImage class]];
    
//    NSLog(@"CacheOne is %@",cacheOne);
    NSLog(@"CacheTwo is %@",cacheTwo);
//    NSLog(@"CacheThree is %@",cacheThree);
}
- (void)testAddingEntity
{
    CWUtils* utils = [CWUtils sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(furtherAddingEntityTest:) name:@"furtherTestNotification" object:utils];
    if(![utils isContextReady:[CWImage class]]){
        [NSThread sleepForTimeInterval:1.0];
    }
    
    
    
}

- (void)furtherAddingEntityTest:(NSNotification*)notification
{
    CWUtils* utils = [CWUtils sharedInstance];
    XCTAssert([utils isContextReady:[CWImage class]]);
    
    NSArray* scheme = @[[[CWCacheLRUScheme alloc] init],[[CWCacheLFUScheme alloc] init],[[CWCacheRandomScheme alloc] init]];
    NSArray* ratio = @[[NSNumber numberWithDouble:5.0],[NSNumber numberWithDouble:3.0],[NSNumber numberWithDouble:2.0]];
    
    CWCache* cacheOne = [[CWCache alloc] initWithPriority:high andSchemes:scheme withScoreRatio:ratio forClass:[CWImage class]];
    
    NSLog(@"CacheOne is %@",cacheOne);
    CWEntity* entityOne = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1001"];
    CWEntity* entityTwo = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1002"];
    CWEntity* entityThree = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1003"];
    CWEntity* entityFour = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1004"];
    CWEntity* entityFive = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1005"];
    CWEntity* entitySix = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1006"];
    CWEntity* entitySeven = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1007"];
    [cacheOne addEntity:entityOne];
//    NSLog(@"CacheOne is %@",cacheOne);
    [cacheOne addEntity:entityTwo];
//    NSLog(@"CacheOne is %@",cacheOne);
    [cacheOne addEntity:entityThree];
//    NSLog(@"CacheOne is %@",cacheOne);
    [cacheOne addEntity:entityFour];
//    NSLog(@"CacheOne is %@",cacheOne);
    [cacheOne addEntity:entityFive];
//    NSLog(@"CacheOne is %@",cacheOne);
    [cacheOne addEntity:entitySix];
//    NSLog(@"CacheOne is %@",cacheOne);
    [cacheOne addEntity:entitySeven];
//    NSLog(@"CacheOne is %@",cacheOne);
    
    [cacheOne getEntityFromCacheWithId:@"1004"];
    [cacheOne getEntityFromCacheWithId:@"1005"];
    [cacheOne getEntityFromCacheWithId:@"1005"];
    [cacheOne getEntityFromCacheWithId:@"1007"];
    [cacheOne getEntityFromCacheWithId:@"1007"];
    [cacheOne getEntityFromCacheWithId:@"1007"];
    CWEntity* entityone = [cacheOne getEntityFromCacheWithId:@"1001"];
    CWEntity* entitytwo = [cacheOne getEntityFromCacheWithId:@"1002"];
    CWEntity* entitythree = [cacheOne getEntityFromCacheWithId:@"1003"];
    CWEntity* entityfour = [cacheOne getEntityFromCacheWithId:@"1004"];
    CWEntity* entityfive = [cacheOne getEntityFromCacheWithId:@"1005"];
    CWEntity* entitysix = [cacheOne getEntityFromCacheWithId:@"1006"];
    CWEntity* entityseven = [cacheOne getEntityFromCacheWithId:@"1007"];
    NSLog(@"one is %@",entityone);
    NSLog(@"two is %@",entitytwo);
    NSLog(@"three is %@",entitythree);
    NSLog(@"four is %@",entityfour);
    NSLog(@"five is %@",entityfive);
    NSLog(@"six is %@",entitysix);
    NSLog(@"seven is %@",entityseven);
    
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end














