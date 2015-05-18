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
@property (nonatomic) dispatch_queue_t queue;

@end

static CWCacheManager* sharedInstace;

@implementation CWCacheManager

+ (instancetype)sharedInstance{
    if(!sharedInstace){
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            sharedInstace = [[CWCacheManager alloc] init];
            [sharedInstace caches];
        });
    }
    return sharedInstace;
}

- (CWCache*)getCacheForManagedObjectWithClassName:(Class)className
{
    if(!className) return nil;
    NSString* name = NSStringFromClass(className);
    if(self.caches[name]){
        return self.caches[name];
    }
    CWCache* cache = [[CWCache alloc]initWithPriority:defaultLevel andSchemes:nil forClass:className];
    self.caches[name]=cache;
    return cache;
}

- (CWCache*)getCacheForManagedObjectWithClassName:(Class)className withSchemes:(NSDictionary*)schemes andPriority:(CWCachePriority)priority
{
    if(!className || !priority || priority>3 || priority<=0){
        @throw [NSException exceptionWithName:@"Invalid input"
                                       reason:@"One or more of the input params are invalid "
                                     userInfo:NULL];
    }
    CWCache* cache = [[CWCache alloc] initWithPriority:priority andSchemes:schemes forClass:className];
    self.caches[NSStringFromClass(className)] = cache;
    
    return cache;
}

/*
 TODO: This method needs to be improved.
 Removes the reference to the caches from the lowest priority
 */
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
