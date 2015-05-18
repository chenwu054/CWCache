//
//  CWCache.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWCache.h"
#import <malloc/malloc.h>
#import "CWUtils.h"

#define DEFAULT_CAPACITY 20

@interface CWCache ()

@property (nonatomic) NSMutableDictionary* map;

@property (nonatomic) NSInteger countLimit;
@property (nonatomic) NSInteger memLimit;
@property (nonatomic) NSString* className;

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
                        forClass:(Class)className
{
    self=[super init];
    if(self){
        self.priority=priority;
        self.className=NSStringFromClass(className);
        self.scheme=[schemes allKeys];
        NSMutableArray* mutableRatio = [[NSMutableArray alloc] initWithCapacity:self.scheme.count];
        double ratioSum=0;
        NSNumber* ratio =nil;
        /*
         normalize ratio
         */
        for(id k in self.scheme){
            if(![k conformsToProtocol:@protocol(CWCacheSchemeDelegate) ]){
                @throw [NSException exceptionWithName:@"Unexpected type"
                                               reason:@"Schemes key does not conform to CWCacheSchemeDelegate protocol"
                                             userInfo:NULL];
            }
            ratio = schemes[k];
            if(![ratio isKindOfClass:[NSNumber class]]){
                @throw [NSException exceptionWithName:@"Unexpected type"
                                               reason:@"Ratio is not NSNumber type"
                                             userInfo:NULL];
            }
            double r = [(NSNumber*)schemes[k] doubleValue];
            if(r<0){
                @throw [NSException exceptionWithName:@"Invalid ratio value"
                                               reason:@"Negative ratio value is not allowed"
                                             userInfo:NULL];
            }
            ratioSum += r;
            [mutableRatio addObject:schemes[k]];
        }
        for(int i=0;i<mutableRatio.count;i++){
            double cur = [(NSNumber*)[mutableRatio objectAtIndex:i] doubleValue];
            [mutableRatio replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:(cur/ratioSum)]];
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
                        forClass:(Class)className;
{
    if(!priority || !schemes || !ratio || schemes.count!=ratio.count || !className){
        @throw [[NSException alloc] initWithName:@"Invalid parameter"
                                          reason:@"One or more of the input params is/are invalid"
                                        userInfo:NULL];
    }
    self=[super init];
    if(self){
        self.priority=priority;
        self.className=NSStringFromClass(className);
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
            /*
             normalize;
             */
            double ratioSum=0.0;
            for(int i =0;i<ratio.count;i++){
                if(![[ratio objectAtIndex:i] isKindOfClass:[NSNumber class]]){
                    @throw [NSException exceptionWithName:@"Unexpected type"
                                                   reason:@"Ratio is not NSNumber type"
                                                 userInfo:NULL];
                }
                double r = [(NSNumber*)[ratio objectAtIndex:i] doubleValue];
                if(r<0){
                    @throw [NSException exceptionWithName:@"Invalid ratio value"
                                                   reason:@"Negative ratio value is not allowed"
                                                 userInfo:NULL];
                }
                ratioSum+=r;
            }
            NSMutableArray* arr =[[NSMutableArray alloc] init];
            for(int i=0;i<ratio.count;i++){
                double number =[(NSNumber*)[ratio objectAtIndex:i] doubleValue];
                [arr addObject:[NSNumber numberWithDouble:(number/ratioSum)]];
            }
            self.ratio = [arr copy];
        }
        [self map];
        [self pq];
        self.countLimit=0;
        self.memLimit=0;
    }
    return self;
}


- (void)addEntity:(CWEntity*)entity
{
    //add it to map
    if(!entity.entityId || entity.entityId.length==0)
        return;
    if(![self.className isEqualToString:entity.className]){
        @throw [NSException exceptionWithName:@"Wrong class"
                                       reason:@"The entity to be added is of different class than the cache!"
                                     userInfo:NULL];
    }
    //insert the entity into core data
    [[CWUtils sharedInstance] insertEntity:entity];
    //recalculate the avgScore and set it to initial values
    double sum=0;
    for(NSInteger i=0;i<self.scheme.count;i++){
        id<CWCacheSchemeDelegate> scheme = [self.scheme objectAtIndex:i];
        [scheme setInitialScoreToEntity:entity inCache:self atIndexInSchemes:i];
        sum += [(NSNumber*)[self.ratio objectAtIndex:i] doubleValue] * [(NSNumber*)[entity.score objectAtIndex:i] doubleValue];
    }
    entity.avgScore= [NSNumber numberWithDouble:sum];
    
    //update the priority queue.
    if(self.map[entity.entityId]){
        [self.pq updateEntity:entity];
    }
    else{
        [self.pq addEntity:entity];
    }
    self.map[entity.entityId]=entity;
    
//  Delete entities when the current cound exceeds the countLimit;
    while(self.pq.size > self.countLimit){
        for(int i=0;i<self.scheme.count;i++){
            id<CWCacheSchemeDelegate> scheme = [self.scheme objectAtIndex:i];
            if([scheme respondsToSelector:@selector(willPopEntityFromCache:)]){
                [scheme willPopEntityFromCache:self];
            }
        }
        CWEntity* toDelete = [self.pq pop];
        [self.map removeObjectForKey:toDelete.entityId];
        
        for(int i=0;i<self.scheme.count;i++){
            id<CWCacheSchemeDelegate> scheme = [self.scheme objectAtIndex:i];
            if([scheme respondsToSelector:@selector(didPopEntity:fromCache:)]){
                [scheme didPopEntity:toDelete fromCache:self];
            }
        }
    }
}

- (CWEntity*)getEntityFromCacheWithId:(NSString*)entityId
{
    //1. get it from map
    if(self.map[entityId]){
        CWEntity* entity = self.map[entityId];
        double sum=0;
        for(int i=0;i<self.scheme.count;i++){
            id<CWCacheSchemeDelegate> scheme = [self.scheme objectAtIndex:i];
            [scheme didQueryEntity:entity inCache:self atIndexInSchemes:i];
            sum += [(NSNumber*)[self.ratio objectAtIndex:i] doubleValue] * [(NSNumber*)[entity.score objectAtIndex:i] doubleValue];
        }
        entity.avgScore= [NSNumber numberWithDouble:sum];
        //update the priority queue
        [self.pq updateEntity:entity];
        return entity;
    }
    //2. get it from core data
    else{
        NSArray* arr = [[CWUtils sharedInstance] queryEntityClass:self.className andId:entityId];
        //if core data has the entity
        if(arr && arr.count>0){
            NSManagedObject* object = [arr firstObject];
            CWEntity* newEntity = [[CWEntity alloc] initWithManagedObject:object andId:[object valueForKey:ENTITY_ID_KEY]];
            double sum = 0;
            for(int i=0;i<self.scheme.count;i++){
                id<CWCacheSchemeDelegate> scheme = [self.scheme objectAtIndex:i];
                [scheme setInitialScoreToEntity:newEntity inCache:self atIndexInSchemes:i];
                sum += [(NSNumber*)[self.ratio objectAtIndex:i] doubleValue] * [(NSNumber*)[newEntity.score objectAtIndex:i] doubleValue];
            }
            newEntity.avgScore= [NSNumber numberWithDouble:sum];
            //add to priority queue;
            [self.pq addEntity:newEntity];
            self.map[newEntity.entityId] = newEntity;
            return newEntity;
        }
    }
    return nil;
}

- (NSArray*)getSchemes
{
    return self.scheme;
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
- (void)deleteHalf
{
    NSInteger curSize = self.pq.size;
    while(self.pq.size > MIN((curSize+1)/2,self.countLimit) && self.pq.size>0){
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
