//
//  CWUtils.m
//  CrazyCache
//
//  Created by chen on 5/12/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWUtils.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "CWImage.h"

#define DIRECTORY_NAME @"CWCache"

@interface CWUtils ()

@property (nonatomic) NSManagedObjectContext* context;

@property (nonatomic) NSURL* documentURL;
@property (nonatomic) NSURL* document;
/**
 * This map is filename : UIManagedDocument;
 */
@property (nonatomic) NSMutableDictionary* documentMap;

@property (nonatomic) NSMutableDictionary* contextMap;

@end

@implementation CWUtils

static CWUtils* instance;

+ (CWUtils*)sharedInstance
{
    if(!instance){
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            instance=[[CWUtils alloc] init];
            //load all the documents 
            NSString* urlString = [[instance getDocumentURL] URLByAppendingPathComponent:[instance relativeFilename:@""]].path;
            NSLog(@"Utils url is %@",urlString);
            NSArray* arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:urlString error:NULL];
            for(NSString* file in arr){
                [instance openManagedDocumentWithFilename:file withCompletionHandler:nil];
            }
        });
    }
    return instance;
}

- (NSString*)getDocument
{
    NSURL* documentsDirectory = [self getDocumentURL];
    return documentsDirectory.path;
}

- (NSURL*)getDocumentURL
{
    if(!self.documentURL || self.documentURL.path.length==0){
        self.documentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    }
    return self.documentURL;
}

- (NSString*)relativeFilename:(NSString*)filename
{
    if(filename && filename.length>0){
        return [NSString stringWithFormat:@"%@/%@",DIRECTORY_NAME,filename];
    }
    else{
        return DIRECTORY_NAME;
    }
}

- (NSURL*)getDocumentURLWithFile:(NSString*)filename
{
    return [[self getDocumentURL] URLByAppendingPathComponent:[self relativeFilename:filename]];
}

- (void)createManagedDocumentWithFilename:(NSString*)filename withCompletionHandler:(void(^)(BOOL success))handler
{
    NSURL* fileURL= [[self getDocumentURL] URLByAppendingPathComponent:[self relativeFilename:filename]];
    BOOL notDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path] isDirectory:&notDir]){
        @throw [NSException exceptionWithName:@"File exists"
                                       reason:@"file already exists"
                                     userInfo:NULL];
    }
    else{
        NSURL* parentDir = [[self getDocumentURL] URLByAppendingPathComponent:[self relativeFilename:@""]];
        [[NSFileManager defaultManager] createDirectoryAtURL:parentDir
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:NULL];
    }
    
    UIManagedDocument* document = [[UIManagedDocument alloc] initWithFileURL:fileURL];
    NSLog(@"Debug: fileURL is %@",fileURL);
    [document saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating
      completionHandler:^(BOOL success) {
        if(handler){
            handler(success);
        }
    }];
    
}

- (UIManagedDocument*)openManagedDocumentWithFilename:(NSString*)filename
                                withCompletionHandler:(void(^)(BOOL success, UIManagedDocument* thisDocument))handler
{
    BOOL notDir = NO;
    NSURL* url = [self getDocumentURLWithFile:filename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:url.path isDirectory:&notDir]){
        [self createManagedDocumentWithFilename:filename withCompletionHandler:nil];
//        @throw [NSException exceptionWithName:@"File does not exist" reason:@"file does not exist" userInfo:NULL];
    }
    UIManagedDocument* doc= nil;
    if(self.documentMap[filename]){
        doc = self.documentMap[filename];
    }
    else{
        doc=[[UIManagedDocument alloc] initWithFileURL:url];
        NSLog(@"document state is %lu",(unsigned long)doc.documentState);
//        self.documentMap[filename]=doc;
    }
    
    if(doc && doc.documentState == UIDocumentStateClosed){
        [doc openWithCompletionHandler:^(BOOL success) {
            NSLog(@"!!!Document opended");
            self.documentMap[filename]=doc;
            NSLog(@"doc state is %lu",(unsigned long)doc.documentState);
            if(handler){
                handler(success,doc);
            }
            
//            [NSThread sleepForTimeInterval:5]; //tests only finish with all tasks are done on all
        }];
    }

    NSLog(@"the document url is %@",url);
    return doc;
}


- (BOOL)isContextReady:(Class)className
{
    BOOL ret = YES;
    if(!self.contextMap[NSStringFromClass(className)]){
        ret=NO;
        [self getContextForFilename:NSStringFromClass(className)];
    }
    return ret;
}
- (NSManagedObjectContext*)getContextForFilename:(NSString*)filename
{
    if(!filename || filename.length==0)
        return nil;
    NSManagedObjectContext* context = nil;
    
    if(self.contextMap[filename]){
        context = self.contextMap[filename];
    }
    else{
        UIManagedDocument* document = [self openManagedDocumentWithFilename:filename
                                                      withCompletionHandler:^(BOOL success,UIManagedDocument* document) {
                                                          if(success && document && document.documentState == UIDocumentStateNormal){
                                                              self.contextMap[filename] = document.managedObjectContext;
                                                              
                                                              NSLog(@"context is %@",self.contextMap[filename]);
//                                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"furtherTestNotification" object:self];
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"furtherTestNotification" object:self userInfo:@{@"className":filename}];
                                                          }
                                                          
//                                                          dispatch_semaphore_signal(self.semaphore);
                                                      }];
        if(document && document.documentState==UIDocumentStateNormal){
            context = document.managedObjectContext;
            self.contextMap[filename]=context;
            NSLog(@"document state2 is %lu",(unsigned long)document.documentState);
        }
    }
    return context;
}

- (NSArray*)getPropertyNameListOfObject:(id)object
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
        id value = [object valueForKey:[NSString stringWithUTF8String:name]];
        NSLog(@"value is %@",value);
    }
    free(properties);
//    NSLog(@"Names: %@", propertyNames);
    return propertyNames;
}

#pragma mark - 
#pragma mark CRUD methods
/*
 assumes the name is underlying item class
 
 */
- (void)addNewEntity:(CWEntity*)entity
{
    if(!entity || !entity.entityId || entity.entityId.length==0){
        return ;
    }
    
    /*
     check if it is there
     */
    id ret = [self queryEntityClass:entity.className andId:entity.entityId];
    if(ret){
        @throw [NSException exceptionWithName:@"Entitiy already exists"
                                       reason:@"An entity with the entityId already exists in core data"
                                     userInfo:NULL];
    }
    /*
     insert into context
     */
    NSManagedObjectContext* context = [self getContextForFilename:entity.className];
    //    NSLog(@"item class is %@",entity.className);
    NSEntityDescription* desc = nil;
    @try{
        desc = [NSEntityDescription insertNewObjectForEntityForName:entity.className
                                             inManagedObjectContext:context];
    }
    @catch(NSException* e){
        NSLog(@"exception is %@",e.reason);
    }
    [desc setValue:entity.entityId forKey:ENTITY_ID_KEY];
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(NSClassFromString(entity.className), &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        NSString* name =[NSString stringWithUTF8String: property_getName(property)];
        if([name isEqualToString:ENTITY_ID_KEY]){
            continue;
        }
        id value = entity.properties[name];
        //        [propertyNames addObject:[NSString stringWithUTF8String:name]];
        [desc setValue:value forKey:name];
        //        NSLog(@"value is %@",value);
    }
    free(properties);
    [context save:NULL];
}

/*
 assumes the name is underlying item class
 
 */
- (void)insertEntity:(CWEntity*)entity
{
    if(!entity || !entity.entityId || entity.entityId.length==0){
        return ;
    }
    NSManagedObjectContext* context = [self getContextForFilename:entity.className];
    if(!context){
        @throw [NSException exceptionWithName:@"NSManagedContext unavailable"
                                       reason:@"Context unavailable, inserting entity failed!"
                                     userInfo:NULL];
    }
    /*
     check if it is there
     */
    NSArray* ret = [self queryEntityClass:entity.className andId:entity.entityId];
    if(ret && ret.count>0){
        for(NSInteger i=0;i<ret.count;i++){
            NSManagedObject* object = [ret objectAtIndex:i];
            [context deleteObject:object];
        }
    }
    /*
     insert into context
     */
//    NSLog(@"item class is %@",entity.className);
    NSEntityDescription* desc = nil;
    @try{
         desc = [NSEntityDescription insertNewObjectForEntityForName:entity.className
                                              inManagedObjectContext:context];
        [desc setValue:entity.entityId forKey:ENTITY_ID_KEY];
        unsigned int propertyCount = 0;
        objc_property_t * properties = class_copyPropertyList(NSClassFromString(entity.className), &propertyCount);
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            NSString* name =[NSString stringWithUTF8String: property_getName(property)];
            if([name isEqualToString:ENTITY_ID_KEY]){
                continue;
            }
            id value = entity.properties[name];
            //        [propertyNames addObject:[NSString stringWithUTF8String:name]];
            [desc setValue:value forKey:name];
            //        NSLog(@"value is %@",value);
        }
        free(properties);
        [context save:NULL];
    }
    @catch(NSException* e){
        NSLog(@"Inserting new entity to context: %@ failed with exception is %@",context, e.reason);
    }
}


- (NSArray*)queryEntityClass:(NSString*)className andId:(NSString*)entityId
{
    if(!className || className.length==0){
        return nil;
    }
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:className];
    request.fetchBatchSize=10;
    request.fetchLimit=10;
    NSSortDescriptor* sorter = [NSSortDescriptor sortDescriptorWithKey:ENTITY_ID_KEY ascending:YES];
    if(entityId && entityId.length>0){
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"cwid = %@",entityId];
        request.sortDescriptors = @[sorter];
        request.predicate=predicate;
    }
    
    NSManagedObjectContext* context = [self getContextForFilename:className];
//    NSLog(@"request is %@ and context is %@",request,context);
    NSError* error;
    NSArray* results = [context executeFetchRequest:request error:&error];
//    for(int i =0;i<results.count;i++){
//        CWImage* image = (CWImage*)[results objectAtIndex:i];
//        NSLog(@"image %d is %@,%@,%@,%@",i,image.cwid,image.imageInitDate,image.imageId,image.imageContent);
//    }
    
    return results;
}

- (void)updateEntity:(CWEntity*)entity
{
    
}

- (void)deleteEntityWithEntityId:(NSString*)entityId ofClassName:(NSString*)className
{
    if(!entityId || entityId.length==0 || !className || className.length==0) return;
    NSManagedObjectContext* context = [self getContextForFilename:className];
    if(!context){
        //TODO: should throw exception;
        return;
    }
    NSArray* arr = [self queryEntityClass:className andId:entityId];
    if(arr){
        for(int i=0;i<arr.count;i++){
            [context deleteObject:[arr objectAtIndex:i]];
        }
    }
}


#pragma mark -
#pragma mark init methods
- (NSMutableDictionary*)documentMap
{
    if(!_documentMap){
        _documentMap = [[NSMutableDictionary alloc] init];
    }
    return _documentMap;
}

- (NSMutableDictionary*)contextMap
{
    if(!_contextMap){
        _contextMap=[[NSMutableDictionary alloc] init];
    }
    return _contextMap;
}


@end
