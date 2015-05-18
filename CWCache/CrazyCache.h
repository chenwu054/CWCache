//
//  CrazyCache.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CWCache.h"

//! Project version number for CrazyCache.
FOUNDATION_EXPORT double CrazyCacheVersionNumber;

//! Project version string for CrazyCache.
FOUNDATION_EXPORT const unsigned char CrazyCacheVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CrazyCache/PublicHeader.h>


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

