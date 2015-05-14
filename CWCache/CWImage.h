//
//  CWImage.h
//  CWCache
//
//  Created by chen on 5/14/15.
//  Copyright (c) 2015 wu.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWImage : NSManagedObject

@property (nonatomic, retain) NSString * cwid;
@property (nonatomic, retain) NSString * imageContent;
@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSDate * imageInitDate;

@end
