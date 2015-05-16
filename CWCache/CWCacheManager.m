//
//  CWCacheManager.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWCacheManager.h"
@interface CWCacheManager ()

@property (nonatomic) NSMutableDictionary* caches;

@end

static CWCacheManager* sharedInstace;

@implementation CWCacheManager

+ (instancetype)sharedInstance{
    if(!sharedInstace){
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            sharedInstace = [[CWCacheManager alloc] init];
        });
    }
    return sharedInstace;
}

- (CWCache*)getCacheForManagedObjectWithClassName:(Class)className
{
    if(!className) return nil;
    if(self.caches[NSStringFromClass(className)]){
        return self.caches[NSStringFromClass(className)];
    }
    CWCache* cache = [[CWCache alloc] initWithPriority:defaultLevel andSchemes:nil];
    self.caches[NSStringFromClass(className)]=cache;
    return cache;
}

- (void)freeMoreSpace
{
    if(self.caches.count==0) return;
    
    NSString* cacheName=nil;
    for(NSString* key in self.caches){
        if(!cacheName){
            cacheName = key;
        }
        else{
            CWCache* last =  self.caches[cacheName];
            CWCache* current = self.caches[key];
            if(last.priority>current.priority){
                cacheName = key;
            }
        }
    }
    [self.caches removeObjectForKey:cacheName];
}

- (void)deleteCache:(NSString*)cacheName
{
    if(!self.caches[cacheName]) return;
    [self.caches removeObjectForKey:cacheName];
}


#pragma mark - 
#pragma mark init methods
- (NSMutableDictionary*)caches
{
    if(!_caches){
        _caches=[[NSMutableDictionary alloc] init];
    }
    return _caches;
}

@end
