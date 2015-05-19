//
//  CWCacheLFUScheme.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWCacheLFUScheme.h"

@implementation CWCacheLFUScheme

@synthesize count;

- (instancetype)init
{
    self = [super init];
    if(self){
        self.count=1;
    }
    return self;
}

- (void)didQueryEntity:(CWEntity*)entity
               inCache:(CWCache*)cache
      atIndexInSchemes:(NSInteger)index
{
    if(!entity || !cache || index<0){
        @throw [NSException exceptionWithName:@"Invalid input"
                                       reason:@"One or more input parameters are invalid"
                                     userInfo:NULL];
    }
    NSArray* schemes = [cache getSchemes];
    if(schemes.count<=index || ![[schemes objectAtIndex:index] isKindOfClass:[self class]]){
        NSLog(@"!WARNING: Skipping updating scheme score in LRU scheme");
        return;
    }
    NSLog(@"Calling didQueryEntity in LFU Scheme");
    NSMutableArray* arr =  entity.score;
    NSNumber *count = [arr objectAtIndex:index];
    if(self.count<[count integerValue]+1){
        self.count=[count integerValue]+1;
    }
    [arr replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:[count integerValue]+1]];
}

- (void)setInitialScoreToEntity:(CWEntity*)entity
                        inCache:(CWCache*)cache
               atIndexInSchemes:(NSInteger)index
{
    if(!entity || !cache || index<0){
        @throw [NSException exceptionWithName:@"Invalid input"
                                       reason:@"One or more input parameters are invalid"
                                     userInfo:NULL];
    }
    NSArray* schemes = [cache getSchemes];
    
    if(schemes.count<=index || ![[schemes objectAtIndex:index] isKindOfClass:[self class]]){
        NSLog(@"!WARNING: Skipping updating scheme score in LFU scheme");
        return;
    }
    else if(entity.score.count <= index){
        [entity.score addObject:[NSNumber numberWithInteger:1]];
    }
    else{
        [entity.score replaceObjectAtIndex:index
                                withObject:[NSNumber numberWithInteger:1]];
    }
    
    NSLog(@"Calling setInitialScoreToEntity in LFU Scheme");
}


- (id)copyWithZone:(NSZone*)zone
{
    id<CWCacheSchemeDelegate> copy = [[[self class] allocWithZone:zone] init];
    
    return  copy;
}

- (BOOL)isEqual:(id)object
{
    return [object isMemberOfClass:[self class]];
}

@end




















