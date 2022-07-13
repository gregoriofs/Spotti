//
//  Workout.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "Workout.h"
#import <Parse/Parse.h>

@implementation Workout

@dynamic objective;
@dynamic focusAreas;
@dynamic frequency;
@dynamic createdAt;
@dynamic completed;
@dynamic exerciseArray;
@dynamic user;
+ (nonnull NSString *)parseClassName {
    return @"Workout";
}
+ (void)postWorkout: (Workout*)workout completionBlock: (PFBooleanResultBlock  _Nullable)completion{
    [workout saveInBackgroundWithBlock:completion];
}

@end
