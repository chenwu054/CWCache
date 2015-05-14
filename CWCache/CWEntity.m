//
//  CWEntity.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWEntity.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@interface CWEntity ()

//@property (nonatomicm,readwrite) NSString* className;

@end

@implementation CWEntity

- (instancetype)initWithClass:(Class)objectClass andId:(NSString*)entityId
{
    self = [super init];
    if(!self) return nil;
    self.className=NSStringFromClass(objectClass);
    self.avgScore=0;
    self.entityId=entityId;
    [self.properties removeAllObjects];
    return self;
}


#pragma mark - 
#pragma mark init methods
- (NSMutableArray*)score
{
    if(!_score){
        _score=[[NSMutableArray alloc] init];
    }
    return _score;
}

- (NSMutableDictionary*)properties
{
    if(!_properties){
        _properties = [[NSMutableDictionary alloc] init];
    }
    return _properties;
}
@end
