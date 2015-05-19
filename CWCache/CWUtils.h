//
//  CWUtils.h
//  CrazyCache
//
//  Created by chen on 5/12/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWEntity.h"

@interface CWUtils : NSObject

+ (CWUtils*)sharedInstance;

@property (nonatomic)dispatch_semaphore_t semaphore;

/**
 * @abstract Get the document directory 
 */
- (NSString*)getDocument;

/**
 * @abstract Get the absolute URL of the file under document dir
 * @param filename The file name
 */
- (NSURL*)getDocumentURLWithFile:(NSString*)filename;

/**
 * @discussion Creates an UIManagedDocument with filename in document directory
 * @param filename The filename
 * @param handler After creating file, handler will be performed
 */
- (void)createManagedDocumentWithFilename:(NSString*)filename withCompletionHandler:(void(^)(BOOL success))handler;

/**
 * @discussion Opens the UIManagedDocumentWithFilename
 *
 */
- (UIManagedDocument*)openManagedDocumentWithFilename:(NSString*)filename
                                withCompletionHandler:(void(^)(BOOL success,UIManagedDocument* thisDocument))handler;

/**
 * @discussion Get the NSManagedContext from the document named filename.
 * It will try to open the document if not already open.
 * @param filename The name of the file.
 */
- (NSManagedObjectContext*)getContextForFilename:(NSString*)filename;

/**
 * @discussion Add a new entity to its UIManagedDocument. If one or more
 * entities with the same CWID already exist, then it will delete all of them first.
 * @param entity The CWEntity to be added to core data
 */
- (void)insertEntity:(CWEntity*)entity;

/**
 * @discussion Fetch the CWEntity in the context for the given entity ID
 * If entityId is not provided, it will do return all the records 
 * If entityId is provided, it will search for the unique entity.
 * @param className The name of the CWEntity.item class. This specifies which NSManagedContext to fetch the entity from
 * @param entityId The entity ID for the fetch.
 **/
- (NSArray*)queryEntityClass:(NSString*)className andId:(NSString*)entityId;

/**
 * @discussion
 *
 */
- (void)updateEntity:(CWEntity*)entity;

/**
 * @discussion Remove the entity 
 * @param entityId The ID associated with the entity to be removed;
 * @param className The name of Class of the NSManagedObject
 */
- (void)deleteEntityWithEntityId:(NSString*)entityId ofClassName:(NSString*)className;

/**
 * @discussion
 * @param 
 */
- (BOOL)isContextReady:(Class)className;

@end









