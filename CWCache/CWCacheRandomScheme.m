//
//  CWCacheRandomScheme.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWCacheRandomScheme.h"
@interface CWCacheRandomScheme ()


@end

@implementation CWCacheRandomScheme

@synthesize count;

- (instancetype)init
{
    self = [super init];
    if(self){
        self.count=1;
    }
    return self;
}
- (void)didQueryEntity:(CWEntity*)entity inCache:(CWCache*)cache atIndexInSchemes:(NSInteger)index
{
    if(!entity || !cache || index<0){
        @throw [NSException exceptionWithName:@"Invalid input"
                                       reason:@"One or more input parameters are invalid"
                                     userInfo:NULL];
    }
    NSArray* schemes = [cache getSchemes];
    if(schemes.count<=index || ![[schemes objectAtIndex:index] isKindOfClass:[self class]]){
        NSLog(@"!WARNING: Skipping updating scheme score in random scheme");
        return;
    }
    NSLog(@"Calling didQueryEntity in Random Scheme");
}

- (void)setInitialScoreToEntity:(CWEntity*)entity inCache:(CWCache*)cache atIndexInSchemes:(NSInteger)index
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
        NSNumber* count = [entity.score objectAtIndex:index];
        [entity.score replaceObjectAtIndex:index
                                withObject:[NSNumber numberWithInteger:[count integerValue]+1]];
    }
    NSLog(@"Calling setInitialScoreToEntity in Random Scheme");
}

/*
 Randomly selects one entity in the cache
 and set its randomScheme score to 0;
 */
- (void)willPopEntityFromCache:(CWCache*)cache
{
    CWPriorityQueue* q = cache.pq;
    int index = arc4random_uniform((int)q.size);
    NSArray* schemes = cache.getSchemes;
    CWEntity* entity = [q entityAtIndex:index];
    NSMutableArray* arr = entity.score;
    for(int i=0;i<schemes.count;i++){
        if([[schemes objectAtIndex:i] isKindOfClass:[self class]] && i<arr.count){
            [arr replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:0]];
        }
    }
    [q updateEntity:entity];
    NSLog(@"Calling willPopEntityFromCache in Random scheme");
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






















