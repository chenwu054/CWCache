//
//  CWEntity.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWEntity.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@interface CWEntity ()

//@property (nonatomicm,readwrite) NSString* className;

@end

@implementation CWEntity

- (instancetype)initWithClass:(Class)objectClass andId:(NSString*)entityId
{
    self = [super init];
    if(!self) return nil;
    self.className=NSStringFromClass(objectClass);
    self.avgScore=0;
    self.entityId=entityId;
    [self.properties removeAllObjects];
    return self;
}

- (instancetype)initWithManagedObject:(NSManagedObject*)object andId:(NSString*)entityId
{
    self=[super init];
    if(!self) return nil;
    self.className = NSStringFromClass([object class]);
    self.avgScore = 0;
    self.entityId = entityId;
    [self.properties removeAllObjects];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(NSClassFromString(self.className), &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        NSString* name =[NSString stringWithUTF8String: property_getName(property)];
        if([name isEqualToString:ENTITY_ID_KEY]){
            self.properties[ENTITY_ID_KEY]=entityId;
            continue;
        }
        self.properties[name] = [object valueForKey:name];
    }
    free(properties);
    return self;
}

- (id)convertToManagedObject
{
    if(!self.className)
        return nil;
    id ret = [[NSClassFromString(self.className) alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(NSClassFromString(self.className), &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        NSString* propertyName =[NSString stringWithUTF8String: property_getName(property)];
        if([propertyName isEqualToString:ENTITY_ID_KEY]){
            [ret setValue:self.entityId forKey:ENTITY_ID_KEY];
            continue;
        }
        [ret setValue:self.properties[propertyName] forKey:propertyName];
    }
    free(properties);
    return ret;
}

#pragma mark - 
#pragma mark init methods
- (NSMutableArray*)score
{
    if(!_score){
        _score=[[NSMutableArray alloc] init];
    }
    return _score;
}

- (NSMutableDictionary*)properties
{
    if(!_properties){
        _properties = [[NSMutableDictionary alloc] init];
    }
    return _properties;
}
@end
