//
//  CWCache.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWCache.h"
#import <malloc/malloc.h>

#define DEFAULT_CAPACITY 20

@interface CWCache ()

@property (nonatomic) NSMutableDictionary* map;
@property (nonatomic) CWPriorityQueue* pq;
@property (nonatomic) NSInteger countLimit;
@property (nonatomic) NSInteger memLimit;

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
    self.scheme=@[[[CWCacheLRUScheme alloc] init]];
    self.ratio=@[@1.0];
    
    [self map];
    [self pq];
    self.countLimit=0;
    self.memLimit=0;
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
        for(id<CWCacheSchemeDelegate> k in self.scheme){
            [mutableRatio addObject:schemes[k]];
        }
        self.ratio = [mutableRatio copy];
        [self map];
        [self pq];
        self.countLimit=0;
        self.memLimit=0;
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
            self.scheme=@[[[CWCacheLRUScheme alloc] init]];
            self.ratio=@[@1.0];
        }
        else{
            //TODO: checking the sum of ratio is 1
            self.scheme=schemes;
            for(id obj in self.scheme){
                if(![[obj class] conformsToProtocol:@protocol(CWCacheSchemeDelegate)]){
                    @throw [NSException exceptionWithName:@"Invalid input"
                                                   reason:@"Input schemes contains object that doest not conform to the protocol"
                                                 userInfo:NULL];
                }
            }
            self.ratio=ratio;
        }
        [self map];
        [self pq];
        self.countLimit=0;
        self.memLimit=0;
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


- (void)setNumberLimit:(NSInteger)limit
{
    if(limit<0){
        @throw [NSException exceptionWithName:@"Invalid input" reason:@"Limit should be non-negative number" userInfo:NULL];
    }
    self.countLimit=limit;
    while(self.countLimit>self.map.count && self.pq.size>0){
        CWEntity* entity = [self.pq pop];
        [self.map removeObjectForKey:entity.entityId];
    }
}

/**
 *
 */
- (void)setMemoryLimit:(NSInteger)memLimit
{
    if(memLimit<0){
        @throw [NSException exceptionWithName:@"Invalid input" reason:@"Limit should be non-negative number." userInfo:NULL];
    }
    self.memLimit=memLimit;
    long memSize= malloc_size((__bridge const void *)(self.map));
    while(memSize > self.memLimit && self.pq.size>0){
        CWEntity* entity = [self.pq pop];
        [self.map removeObjectForKey:entity.entityId];
    }
}

/**
 * @discussion free up half of the memory. Delete half of cached objects
 *
 */
- (void)freeMemory
{
    NSInteger curSize = self.pq.size;
    while(self.pq.size > (curSize+1)/2 && self.pq.size>0){
        CWEntity* entity=[self.pq pop];
        [self.map removeObjectForKey:entity.entityId];
    }
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
