//
//  CWPriorityQueue.m
//  CrazyCache
//
//  Created by chen on 5/10/15.
//  Copyright (c) 2015 freelance.chen. All rights reserved.
//

#import "CWPriorityQueue.h"
@interface CWPriorityQueue ()

@property (atomic) NSMutableArray* queue;
@property (nonatomic) NSInteger capacity;
@property (nonatomic) dispatch_queue_t customSerialQueue;

@end

@implementation CWPriorityQueue

@synthesize queue=_queue;

- (instancetype)initWithCapacity:(NSInteger)capacity
{
    self = [super init];
    if(!self) return nil;
    self.capacity=capacity;
    
    [self queue];
    [self customSerialQueue];
    
    return self;
}

- (void)addEntity:(CWEntity*)entity
{
    [self.queue addObject:entity];
    entity.index = self.queue.count-1;
    [self percolateUpAtIndex:self.queue.count-1];
}

- (CWEntity*)pop
{
    if(self.queue.count==0){
        return nil;
    }
    CWEntity* ret = [self.queue objectAtIndex:0];
    [self.queue replaceObjectAtIndex:0 withObject:[self.queue objectAtIndex:self.queue.count-1]];
    [self.queue removeLastObject];
    [self percolateDownAtIndex:0];
    return ret;
}

- (void)updateEntity:(CWEntity*)entity
{
    NSInteger idx = entity.index;
    if(idx<=0 || idx>=self.queue.count){
        NSLog(@"!!!ERROR: updating entity index out of bound");
        return;
    }
    [self percolateDownAtIndex:entity.index];
    [self percolateUpAtIndex:entity.index];
}


- (CWEntity*)entityAtIndex:(NSInteger)index
{
    if(index<0 || index >=self.queue.count){
        return nil;
    }
    return [self.queue objectAtIndex:index];
}


- (void)percolateUpAtIndex:(NSInteger)index
{
    if(index<0 || index>=self.queue.count){
        return ;
    }
    __block NSInteger idx=index;
    __block NSInteger nextIdx = (idx-1)/2;
    __block CWEntity* cur=nil;
    __block CWEntity* next=nil;
    dispatch_barrier_async(self.customSerialQueue, ^{
        while(idx!=0 && nextIdx>=0){
            cur = [self.queue objectAtIndex:idx];
            next = [self.queue objectAtIndex:nextIdx];
            if(cur.avgScore >= next.avgScore){
                break;
            }
            CWEntity* tmp = cur;
            [self.queue replaceObjectAtIndex:idx withObject:[self.queue objectAtIndex:nextIdx]];
            [self.queue replaceObjectAtIndex:nextIdx withObject:tmp];
            cur.index=nextIdx;
            next.index=idx;
            
            idx=nextIdx;
            nextIdx=(idx-1)/2;
        }
//        [NSThread sleepForTimeInterval:3];
        //for unit tests only
        dispatch_semaphore_signal(self.semaphore);
    });
}

- (void)percolateDownAtIndex:(NSInteger)index
{
    if(index<0 || index>=self.queue.count){
        return;
    }
    __block NSInteger idx=index;
    __block NSInteger nextIdx=idx*2+1;
    __block CWEntity* cur=nil;
    __block CWEntity* next=nil;
    dispatch_barrier_async(self.customSerialQueue, ^{
        while(nextIdx<self.queue.count){
            cur = [self.queue objectAtIndex:idx];
            next = [self.queue objectAtIndex:nextIdx];
            if(nextIdx+1<self.queue.count && next.avgScore>[self.queue objectAtIndex:nextIdx+1]){
                nextIdx=nextIdx+1;
            }
            next = [self.queue objectAtIndex:nextIdx];
            if(cur.avgScore <= next.avgScore){
                break;
            }
            CWEntity* tmp=cur;
            [self.queue replaceObjectAtIndex:idx withObject:[self.queue objectAtIndex:nextIdx]];
            [self.queue replaceObjectAtIndex:nextIdx withObject:tmp];
            cur.index=nextIdx;
            next.index=idx;
            
            idx=nextIdx;
            nextIdx=idx*2+1;
        }
        // for unit tests only
        dispatch_semaphore_signal(self.semaphore);
    });
}

- (NSMutableArray*)queue
{
    
    static dispatch_once_t predicate;
    if(!_queue){
        dispatch_once(&predicate, ^{
            _queue=[[NSMutableArray alloc] initWithCapacity:self.capacity];
        });
    }
    return _queue;
}

- (void)setQueue:(NSMutableArray *)queue
{
    self.queue=queue;
}

/*
 This is called at instance initialization once.
 */
- (dispatch_queue_t)customSerialQueue
{
    if(!_customSerialQueue){
        /*
         DISPATCH_QUEUE_CONCURRENT in this case makes the queue concurrent.
         This is like a read-write lock meaning that multiple reads can access while only
         one write can access at a time.
         */
        _customSerialQueue = dispatch_queue_create("crazycache.priorityQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _customSerialQueue;
}

- (NSInteger)size
{
    return self.queue.count;
}


- (NSArray*)getQueue
{
    return self.queue;
}

@end
