//
//  Milestone.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 8/4/22.
//

#import "Milestone.h"
#import "Workout.h"
@implementation Milestone
@dynamic user;
@dynamic exercise;
@dynamic weightGoal;
@dynamic repGoal;
@dynamic currentHighestReps;
@dynamic currentHighestWeight;
@dynamic inProgress;
@dynamic metric;

+ (nonnull NSString *)parseClassName {
    return @"Milestone";
}

- (id)initWithValues{
    self = [super init];
    self.user = [GymUser currentUser];
    self.inProgress = [NSNumber numberWithBool:YES];
    self.metric = @"Reps";
    self.currentHighestReps = [NSNumber numberWithInt:0];
    self.currentHighestWeight = [NSNumber numberWithInt:0];
    return self;
}

- (void) update:(Workout *)workout {
    [self.exercise fetchIfNeeded];
    for(Exercise *exercise in workout.exerciseArray){
        [exercise fetchIfNeeded];
        if([exercise.exerciseName isEqualToString:self.exercise.exerciseName] && ([[exercise.updatedAt earlierDate:self.createdAt] isEqual:self.createdAt] || [exercise.updatedAt isEqualToDate:self.createdAt])){
            if([exercise.numberReps intValue] > [self.currentHighestReps intValue]){
                [self setValue:exercise.numberReps forKey:@"currentHighestReps"];
            }
            if([exercise.lastWeight intValue] > [self.currentHighestWeight intValue]){
                [self setValue:exercise.lastWeight forKey:@"currentHighestWeight"];
            }
        }
    }
    if([self.currentHighestReps intValue] >= [self.repGoal intValue] && [self.currentHighestWeight intValue] >= [self.repGoal intValue]){
        self.inProgress = [NSNumber numberWithBool:NO];
    }
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}


@end
