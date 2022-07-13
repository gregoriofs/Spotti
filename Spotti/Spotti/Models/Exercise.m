//
//  Exercise.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "Exercise.h"


@implementation Exercise

@dynamic exerciseName;
@dynamic numberSets;
@dynamic numberReps;
@dynamic exerciseDescription;
@dynamic muscles;
@dynamic user;
@dynamic image;

- (id)initWithDictionary: (NSDictionary *)dict{
    self = [super init];
    self.exerciseName = dict[@"name"];
    self.numberReps = @(0);
    self.numberSets = @(0);
    self.exerciseDescription = dict[@"description"];
    self.muscles = dict[@"muscles"];
    self.user = [PFUser currentUser];
    return self;
}

+ (NSArray* )exercisesFromDictionaries: (NSArray* ) dictionary{
    NSMutableArray *exercises = [[NSMutableArray alloc] init];
    for(NSDictionary* exercise in dictionary){
        Exercise *new = [[Exercise alloc] initWithDictionary:exercise];
        [exercises addObject:new];
    }
    return [exercises copy];
}

+ (void)saveExercise:(Exercise *)exercise completionBlock:(PFBooleanResultBlock)completion{
    [exercise saveInBackgroundWithBlock:completion];
}

+ (nonnull NSString *)parseClassName {
    return @"Exercise";
}

@end

