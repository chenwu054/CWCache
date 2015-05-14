//
//  CWUtilsTests.m
//  CrazyCache
//
//  Created by chen on 5/13/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CWEntity.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "CWUtils.h"
#import "CWImage.h"

@interface CWUtilsTests : XCTestCase

@property (nonatomic) CWUtils* utils;

@end

@implementation CWUtilsTests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

 -(void)save
{
    id entity = [[CWEntity alloc] init];
    NSLog(@"entity class is %@",[entity class]);
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([entity class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
        id value = [entity valueForKey:[NSString stringWithUTF8String:name]];
        NSLog(@"value is %@",value);
    }
    free(properties);
    NSLog(@"Names: %@", propertyNames);
}

- (void)testContextInitialization
{
    NSLog(@"********* CWUtils tests**********");
    [self utils];
    XCTAssert(self.utils);
    NSString* documentDir = [self.utils getDocument];
//    NSLog(@"Document dir is %@",documentDir);
    NSString* fileDir = [self.utils getDocumentURLWithFile:@"CWImage"].path;
//    NSLog(@"File dir is %@",fileDir);
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];

//    XCTAssert(document);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(furtherTests:) name:@"furtherTestNotification" object:self.utils];
    
    NSManagedObjectContext* context = [self.utils getContextForFilename:NSStringFromClass([CWImage class])];
//    UIManagedDocument* document = [utils openManagedDocumentWithFilename:@"chen" withCompletionHandler:^(BOOL success, UIManagedDocument *thisDocument) {
//        NSLog(@"!!!finished");
//    }];
    
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    NSLog(@"state is %lu",(unsigned long)document.documentState);
//    if(!context){
//        context = [utils getContextForFilename:@"chen"];
//    }
//    XCTAssert(context);
    

    
}

- (void)furtherTests:(NSNotification*)notification
{
    
    NSLog(@"received notification");
//    CWImage* imageObject = [[CWImage alloc] init];
//    imageObject.imageContent=@"IMAGE_CONTENT";
//    imageObject.imageId=@"IMAGE_ID";
//    imageObject.imageInitDate = [NSDate date];
    
    CWEntity* entity = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1b1"];
    entity.properties[@"imageContent"] = @"IMAGE_CONTENT";
    entity.properties[@"imageId"] = @"IMAGE_ID";
    entity.properties[@"imageInitDate"]=[NSDate date];
    NSLog(@"self.utils context is %@",[self.utils getContextForFilename:@"CWImage"]);
    [self.utils insertEntity:entity];
    
    CWEntity* entity2 = [[CWEntity alloc] initWithClass:[CWImage class] andId:@"1b2"];
    entity2.properties[@"imageContent"] = @"IMAGE_CONTENT2";
    entity2.properties[@"imageId"] = @"IMAGE_ID2";
    entity2.properties[@"imageInitDate"]=[NSDate date];
    NSLog(@"self.utils context is %@",[self.utils getContextForFilename:@"CWImage"]);
    [self.utils insertEntity:entity2];

    
    CWImage* image = (CWImage*)[self.utils queryEntityClass:NSStringFromClass([CWImage class]) andId:@"1b2"];
    NSLog(@"cwimage is %@,%@,%@,%@",image.cwid,image.imageContent,image.imageId,image.imageInitDate);
    XCTAssert(image);
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
    
//    [NSThread sleepForTimeInterval:100];
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (CWUtils*)utils
{
    if(!_utils){
        _utils=[CWUtils sharedInstance];
    }
    return _utils;
}

@end
