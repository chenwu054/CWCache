//
//  CWPriorityQueue.h
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWEntity.h"

@interface CWPriorityQueue : NSObject

@property (nonatomic)dispatch_semaphore_t semaphore;

/**
 * @abstract Initiates a priority with a predefined capacity
 * @param capacity The initial capacity
 */
- (instancetype)initWithCapacity:(NSInteger)capacity;

/**
 * @abstract Add a new entity to the priority queue
 * @param entity The new entity to be inserted into the queue
 */
- (void)addEntity:(CWEntity*)entity;

/**
 * @abstract Pops the peak of the queue. If the queue is empty, returns nil
 * @return The entity on top of the queue
 */
- (CWEntity*)pop;

/**
 * @abstract If the entity's score is changed and its position will be adjusted
 * @param entity The entity to be updated
 */
- (void)updateEntity:(CWEntity*)entity;

/**
 * @abstract Moves the CWEntity object up in the priority queue given its avgScore is lower
 * @param index The index of CWEntity to be moved up
 */
- (void)percolateDownAtIndex:(NSInteger)index;

/**
 * @abstract Moves the CWEntity object down in the priority queue given its avgScore is higher
 * @param index The index of CWEntity to be moved down
 */
- (void)percolateUpAtIndex:(NSInteger)index;

/**
 * @abstract Get the size of the priority queue
 * @return The size of the priority queue
 */
- (NSInteger)size;

/**
 * @abstract The underneath queue
 * @return The priority queue;
 */
- (NSArray*)getQueue;



@end
