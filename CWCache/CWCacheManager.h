//
//  CWCacheManager.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrazyCache.h"
#import "CWCache.h"

@class CWCache;

@interface CWCacheManager : NSObject


/**
 * @discussion Class method, returns the singleton CWCacheManager instance
 */
+ (instancetype)sharedInstance;

/**
 * @discussion Creat or retrieve the cache given the NSManagedObject class
 * @param className The Class of the underlying NSManagedObject
 */
- (CWCache*)getCacheForManagedObjectWithClassName:(Class)className;

/**
 * @discussion A more specific intance method for creating and retrieving 
 * the cache for the NSManagedObject
 * @param className The Class of the underlying NSManagedObject
 * @param schemes The schemes and score ratio for the cache
 * @param priority The priority of the cache. Lowest priority gets freed up first.
 */
- (CWCache*)getCacheForManagedObjectWithClassName:(Class)className withSchemes:(NSDictionary*)schemes andPriority:(CWCachePriority)priority;

/**
 * @discussion Removes cache strong references to free up memory.
 * Lowest priority caches are removed first.
 */
- (void)freeMoreSpace;


@end
