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
 * @discussion Opens the
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
 * @discussion Add a new entity to its UIManagedDocument. If an 
 * entity with the same CWID already exists, then it will abort addition and return.
 * @param entity The CWEntity to be added to core data
 */
- (void)insertEntity:(CWEntity*)entity;

/**
 * @discussion Fetch the CWEntity in the context for the given entity ID
 * @param className The name of the CWEntity.item class. This specifies which NSManagedContext to fetch the entity from
 * @param entityId The entity ID for the fetch.
 **/
- (CWEntity*)queryEntityClass:(NSString*)className andId:(NSString*)entityId;

/**
 * @discussion
 *
 */
- (void)updateEntity:(CWEntity*)entity;

/**
 * @discussion Remove the entity 
 * @param entity The entity to be removed;
 */
- (void)deleteEntity:(CWEntity*)entity;



@end









