//
//  CWCacheManager.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWCacheManager : NSObject
/**
 * @abstract the enum of the priority. Lower priority will be 
 * discarded first.
 */
typedef enum
{
    low = 1,
    defaultLevel,
    high
}
CWCachePriority;

@end
