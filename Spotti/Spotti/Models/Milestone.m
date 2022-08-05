//
//  Milestone.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 8/4/22.
//

#import "Milestone.h"

@implementation Milestone
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

- (void) update:(Exercise *)exercise completionBlock:(void(^)(int maxReps, int maxWeight))completion{
    NSDate *dateCreated = self.createdAt;
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query whereKey:@"exerciseName" equalTo:self.exercise.exerciseName];
    [query whereKey:@"createdAt" greaterThanOrEqualTo:dateCreated];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        int maximumRep = 0;
        int maxWeight = 0;
        for(Exercise *exercise in objects){
            if([exercise.numberReps intValue] > maximumRep){
                maximumRep =[exercise.numberReps intValue];
            }
            if([exercise.lastWeight intValue] > maxWeight){
                maxWeight =[exercise.lastWeight intValue];
            }
        }
        if (maximumRep > [self.currentHighestReps intValue]){
            self.currentHighestReps = [NSNumber numberWithInt:maximumRep];
        }
        if(maxWeight > [self.currentHighestWeight intValue]){
            self.currentHighestWeight = [NSNumber numberWithInt:maxWeight];
        }
        
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
    }];
}


@end
