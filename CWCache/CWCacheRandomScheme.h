//
//  CWCacheRandomScheme.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWCacheSchemeDelegate.h"

//@protocol CWCacheSchemeDelegate;

@interface CWCacheRandomScheme : NSObject <CWCacheSchemeDelegate>

//randomly selects an item and set its avgScore to 0

@end
