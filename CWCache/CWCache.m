//
//  CWCache.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWCache.h"

#define DEFAULT_CAPACITY 20

@interface CWCache ()

@property (nonatomic) NSMutableDictionary* map;
@property (nonatomic) CWPriorityQueue* pq;

/**
 * @abstract The schemes
 */
//@property (nonatomic)NSDictionary* schemes;

@property (nonatomic)NSArray* scheme;
@property (nonatomic)NSArray* ratio;

@end

@implementation CWCache

- (instancetype)init
{
    self=[super init];
    if(!self) return nil;
    self.priority = defaultLevel;
//    self.schemes=@{NSStringFromClass([CWCacheLRUScheme class]):[NSNumber numberWithDouble:1.0]};
    self.scheme=@[NSStringFromClass([CWCacheLRUScheme class])];
    self.ratio=@[@1.0];
    
    [self map];
    [self pq];
    
    return self;
}

- (instancetype)initWithPriority:(CWCachePriority)priority
                      andSchemes:(NSDictionary*)schemes
{
    self=[super init];
    if(self){
        self.priority=priority;
        self.scheme=[schemes allKeys];
        NSMutableArray* mutableRatio = [[NSMutableArray alloc] initWithCapacity:self.scheme.count];
        for(NSString* k in self.scheme){
            [mutableRatio addObject:schemes[k]];
        }
        self.ratio = [mutableRatio copy];
        [self map];
        [self pq];
    }
    return self;
}

- (instancetype)initWithPriority:(CWCachePriority)priority
                      andSchemes:(NSArray*)schemes
                  withScoreRatio:(NSArray*)ratio
{
    if(!priority || !schemes || !ratio || schemes.count!=ratio.count){
        @throw [[NSException alloc] initWithName:@"Invalid parameter"
                                          reason:@"One or more of the input params is/are invalid"
                                        userInfo:NULL];
    }
    self=[super init];
    if(self){
        self.priority=priority;
        if(schemes.count==0){
            self.scheme=@[NSStringFromClass([CWCacheLRUScheme class])];
            self.ratio=@[@1.0];
        }
        else{
            //TODO: checking the sum of ratio is 1
            self.scheme=schemes;
            self.ratio=ratio;
        }
        [self map];
        [self pq];
    }
    return self;
}



- (void)addEntity:(CWEntity*)entity withId:(NSString*)entityId
{
    //add it to map
    if(!entityId || entityId.length==0)
        return;
    if(self.map[entityId]){
        //TODO: count+1
        return;
    }
    else{
        self.map[entityId]=entity;
    }
    double sum=0;
    for(int i=0;i<self.scheme.count;i++){
        [entity.score addObject:@1];
        sum += 1.0;
    }
    sum = sum/self.scheme.count;
    entity.avgScore= [NSNumber numberWithDouble:sum];
    
    [self.pq addEntity:entity];
    
    //add it to core data
}

- (CWEntity*)getEntityFromCacheWithId:(NSString*)entityId
{
    //1. get it from map
    if(self.map[entityId]){
        CWEntity* ret = self.map[entityId];
        
        
        
        return ret;
    }
    //2. get it from core data
    else{
    
    }
    
    return nil;
}

#pragma mark - 
#pragma mark init methods
- (CWPriorityQueue*)pq
{
    if(!_pq){
        _pq = [[CWPriorityQueue alloc] initWithCapacity:DEFAULT_CAPACITY];
    }
    return _pq;
}

- (NSMutableDictionary*)map
{
    if(!_map){
        _map=[[NSMutableDictionary alloc] initWithCapacity:DEFAULT_CAPACITY];
    }
    return _map;
}
@end
