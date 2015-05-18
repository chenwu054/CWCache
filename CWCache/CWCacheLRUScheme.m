//
//  CWCacheLRUScheme.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWCacheLRUScheme.h"
@interface CWCacheLRUScheme ()

@property (atomic) NSInteger count;

@end

@implementation CWCacheLRUScheme

- (instancetype)init
{
    self = [super init];
    if(self){
        self.count=0;
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
        NSLog(@"!WARNING: Skipping updating scheme score in LRU scheme");
        return;
    }
    NSMutableArray* arr =  entity.score;
    self.count = self.count+1;
    [arr replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:self.count]];
}

- (void)setInitialScoreToEntity:(CWEntity*)entity inCache:(CWCache*)cache atIndexInSchemes:(NSInteger)index
{
    NSArray* schemes = [cache getSchemes];

    if(schemes.count<=index || ![[schemes objectAtIndex:index] isKindOfClass:[self class]]){
        NSLog(@"!WARNING: Skipping updating scheme score in LRU scheme");
        return;
    }
    else if(entity.score.count <=index){
        [entity.score addObject:[NSNumber numberWithInteger:self.count++]];
    }
    else{
        [entity.score replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:self.count++]];
    }
    
}

- (void)willPopEntityFromCache:(CWCache*)cache
{
    
}



@end
