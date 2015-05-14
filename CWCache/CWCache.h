//
//  CWCache.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWCacheManager.h"
#import "CWEntity.h"
#import "CWPriorityQueue.h"
#import "CWCacheRandomScheme.h"
#import "CWCacheLRUScheme.h"
#import "CWCacheLFUScheme.h"


@interface CWCache : NSObject

/**
 * @abstract The priority queue 
 */
@property (nonatomic)CWCachePriority priority;

- (instancetype)initWithPriority:(CWCachePriority)priority andSchemes:(NSDictionary*)schemes;

- (instancetype)initWithPriority:(CWCachePriority)priority andSchemes:(NSArray*)schemes withScoreRatio:(NSArray*)ratio;

/**
 * @brief add a new entity to the cache
 * @param entity the CWEntity to be added
 * @param entityId the ID of added entity
 */
- (void)addEntity:(CWEntity*)entity withId:(NSString*)entityId;

/**
 * @discussion this query first tries to find in the cache. If not found, it will try to find in core data
 * @param entityId the id associated with the entity to be fetched.
 * @return returns CWEntity if found, otherwise return nil.
 */
- (CWEntity*)getEntityFromCacheWithId:(NSString*)entityId;





@end
