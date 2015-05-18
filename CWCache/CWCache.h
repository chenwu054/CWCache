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
#import "CrazyCache.h"

//@class CWCacheRandomScheme;
//@class CWCacheLRUScheme;
//@class CWCacheLFUScheme;



@interface CWCache : NSObject

/**
 * @param pq The min priority queue of the cache. 
 * The top CWEntity is of the lowest avgScore.
 */
@property (nonatomic) CWPriorityQueue* pq;

/**
 * @abstract The priority queue 
 */
@property (nonatomic) CWCachePriority priority; 

/**
 * @discussion Initiates a new CWCache with the given parameters.
 * The given ratios will be normalized.
 * @param priority The priority of the cache
 * @param schemes The schemes to be considered. The values are the ratios
 * pertaining to the schemes
 * @param className The Class of the underlying NSManagedObject
 */
- (instancetype)initWithPriority:(CWCachePriority)priority
                      andSchemes:(NSDictionary*)schemes
                        forClass:(Class)className;

/**
 * @discussion Initiates a new CWCache with the given parameters.
 * The given ratios will be normalized
 * @param priority The priority of the cache
 * @param schemes The schemes to be considered
 * @param ratio The ratio between the schemes for calculating the avgScore
 * @param className The Class of the underlying NSManagedObject
 */
- (instancetype)initWithPriority:(CWCachePriority)priority
                      andSchemes:(NSArray*)schemes
                  withScoreRatio:(NSArray*)ratio
                        forClass:(Class)className;

- (NSArray*)getSchemes;

/**
 * @discussion Sets the limit of the number of CWEntity's should be held in the cache.
 * 
 * @param limit The limit of the number of CWEntity's
 */
- (void)setNumberLimit:(NSInteger)limit;

/**
 * TODO: This is not implemented
 */
- (void)setMemoryLimit:(NSInteger)memLimit;

/**
 * @discussion free up half of the memory. Delete half of cached objects
 *
 */
- (void)deleteHalf;

/**
 * @discussion Add a new entity to the cache. 
 * If there is already one CWEntity in the cache, it will replace 
 * the entity and replace the entity in core data. If for any 
 * reason there are more than one entity in core data, all 
 * entities with the same CWID will be removed and the new entity
 * will be added.
 * @param entity the CWEntity to be added
 * @param entityId the ID of added entity
 */
- (void)addEntity:(CWEntity*)entity;

/**
 * @discussion this query first tries to find in the cache. If not found, it will try to find in core data
 * @param entityId the id associated with the entity to be fetched.
 * @return returns CWEntity if found, otherwise return nil.
 */
- (CWEntity*)getEntityFromCacheWithId:(NSString*)entityId;





@end
