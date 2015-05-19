//
//  CWCacheSchemeDelegate.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWCache.h"
//#import "CWEntity.h"

@class CWCache;

@protocol CWCacheSchemeDelegate <NSObject>

/**
 * @param count This is intended for accumulated count.
 * It can also be used as scale of this particular scheme
 */
@property (nonatomic) NSInteger count;

@required

- (void)didQueryEntity:(CWEntity*)entity inCache:(CWCache*)cache atIndexInSchemes:(NSInteger)index;

- (void)setInitialScoreToEntity:(CWEntity*)entity inCache:(CWCache*)cache atIndexInSchemes:(NSInteger)index;


@optional


//- (void)resetAllEntitiesMaintainOrderInCache:(CWCache*)cache;

- (void)willPopEntityFromCache:(CWCache*)cache;

- (void)didPopEntity:(CWEntity*)entity fromCache:(CWCache*)cache;

@end
