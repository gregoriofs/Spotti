//
//  PriorityQueueNode.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/19/22.
//

#import "PriorityQueueNode.h"

@implementation PriorityQueueNode

- (id) initWithPriority:(NSNumber *)prio user:(GymUser *)user{
    self = [super init];
    self.priority = prio;
    self.user = user;
    return self;
}

@end
