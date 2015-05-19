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
    if(!objectClass || !entityId || entityId.length==0){
        @throw [NSException exceptionWithName:@"Invalid input" reason:@"One or more input parameters are invalid" userInfo:NULL];
    }
    self = [super init];
    if(!self) return nil;
    self.className=NSStringFromClass(objectClass);
    self.avgScore=0;
    self.entityId=entityId;
    [self.properties removeAllObjects];
    [self.score removeAllObjects];
    return self;
}

- (instancetype)initWithManagedObject:(NSManagedObject*)object
                                   andId:(NSString*)entityId
{
    if(!object || !entityId || entityId.length==0){
        @throw [NSException exceptionWithName:@"Invalid input"
                                       reason:@"One or more input parameters are invalid"
                                     userInfo:NULL];
    }
    self=[super init];
    if(!self) return nil;
    self.className = NSStringFromClass([object class]);
    self.avgScore = 0;
    self.entityId = entityId;
    [self.properties removeAllObjects];
    [self.score removeAllObjects];
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

+ (CWEntity*)convertFromManagedObject:(NSManagedObject*)object
{
    if(!object){
        return nil;
    }
    CWEntity* entity = [[CWEntity alloc] initWithClass:[object class] andId:nil];
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        NSString* propertyName =[NSString stringWithUTF8String: property_getName(property)];
        if([propertyName isEqualToString:ENTITY_ID_KEY]){
            entity.entityId=[object valueForKey:ENTITY_ID_KEY];
            continue;
        }
        entity.properties[propertyName]=[object valueForKey:propertyName];
    }
    free(properties);
    return entity;
}

- (NSString*)description
{
    NSString* ret = [NSString stringWithFormat:@"Entity is -> [(cwid: %@)",self.entityId];
    for(NSString* k in self.properties){
        ret = [ret stringByAppendingString:[NSString stringWithFormat:@"(%@ : %@)",k,self.properties[k]]];
    }
    ret = [ret stringByAppendingString:[NSString stringWithFormat:@"], scores:%@ ; avgScore: %@, Class: %@",self.score,self.avgScore,self.className]];
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
