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

@property (nonatomic) Class objectClass;
@property (nonatomic) NSString* className;
@property (nonatomic) NSMutableDictionary* properties;
@property (nonatomic) NSString* entityId;
@property (nonatomic) NSInteger index;
//@property (nonatomic) NSMutableDictionary* scores;
@property (nonatomic) NSMutableArray* score;
@property (nonatomic) NSNumber* avgScore;

/**
 * @discussion May NOT work, since can not set property directly to NSManagedObject
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
 * @discussion May NOT work
 */
- (id)convertToManagedObject;


@end
