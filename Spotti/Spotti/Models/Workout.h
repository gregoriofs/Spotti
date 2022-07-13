//
//  Workout.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GymUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface Workout :  PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *objective;
@property (strong, nonatomic) NSArray *focusAreas;
@property (strong, nonatomic) NSNumber *frequency;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSNumber *completed;
@property (strong, nonatomic) NSArray *exerciseArray;
@property (strong, nonatomic) GymUser *user;
+ (void)postWorkout: (Workout*)workout completionBlock: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
