//
//  CWEntity.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ENTITY_ID_KEY @"cwid"

@interface CWEntity : NSObject

@property (nonatomic) NSString* className;
@property (nonatomic) NSMutableDictionary* properties;
@property (nonatomic) NSString* entityId;
@property (nonatomic) NSInteger index;
//@property (nonatomic) NSMutableDictionary* scores;
@property (nonatomic) NSMutableArray* score;
@property (nonatomic) NSNumber* avgScore;

/**
 * @discussion This is for internal use only. 
 * Do not use this because it may potentially lead to exception
 * @param object The underlying NSManagedObject
 * @param entityId The ID associdated with the object
 */
- (instancetype)initWithManagedObject:(NSManagedObject*)object
                                   andId:(NSString*)entityId;

/**
 * @discussion Initiates a CWEntity object with the given underlying NSManagedObject 
 * @param objectClass The name of the class
 * @param entityId The ID of the entity
 */
- (instancetype)initWithClass:(Class)objectClass andId:(NSString*)entityId;

/**
 * @discussion Convert the NSManagedObject to a new CWEntity
 */
+ (CWEntity*)convertFromManagedObject:(NSManagedObject*)object;


@end
