//
//  Milestone.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 8/4/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Exercise.h"
#import "GymUser.h"
#import "Workout.h"

NS_ASSUME_NONNULL_BEGIN

@interface Milestone : PFObject <PFSubclassing>
@property GymUser *user;
@property Exercise *exercise;
@property NSNumber *weightGoal;
@property NSNumber *repGoal;
@property NSNumber *currentHighestReps;
@property NSNumber *currentHighestWeight;
@property NSString *metric;
@property NSNumber *inProgress;
- (void)update:(Workout *)workout;
- (id)initWithValues;
@end

NS_ASSUME_NONNULL_END
