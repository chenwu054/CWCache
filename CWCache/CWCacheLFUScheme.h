//
//  CWCacheLFUScheme.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWCacheSchemeDelegate.h"

@protocol CWCacheSchemeDelegate;

@interface CWCacheLFUScheme : NSObject <CWCacheSchemeDelegate>

@end
