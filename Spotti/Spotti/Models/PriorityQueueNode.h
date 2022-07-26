//
//  PriorityQueueNode.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/19/22.
//

#import <Foundation/Foundation.h>
#import "GymUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface PriorityQueueNode : NSObject
@property (strong, nonatomic) GymUser *user;
@property (strong, nonatomic) NSNumber *priority;
- (id) initWithPriority:(NSNumber *)prio user:(GymUser *)user;

@end

NS_ASSUME_NONNULL_END
