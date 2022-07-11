//
//  Workout.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "Workout.h"

@implementation Workout 

@dynamic objective;
@dynamic focusAreas;
@dynamic frequency;
@dynamic createdAt;
@dynamic completed;
@dynamic exerciseArray;

-(instancetype)init{
    self = [super init];
    
    self.createdAt = [NSDate date];
    
    return self;
}

+ (nonnull NSString *)parseClassName {
    return @"Workout";
}


- (void)postWorkout: (Workout*)workout completionBlock: (PFBooleanResultBlock  _Nullable)completion{
    
    [workout saveInBackgroundWithBlock:completion];
}



@end
