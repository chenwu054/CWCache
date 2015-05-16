//
//  CWCacheManager.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWCache.h"
@class CWCache;

@interface CWCacheManager : NSObject

+ (instancetype)sharedInstance;



- (CWCache*)getCacheForManagedObjectWithClassName:(Class)className;

- (void)freeMoreSpace;


@end
