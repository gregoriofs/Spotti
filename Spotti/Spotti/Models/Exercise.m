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
@dynamic lastWeight;

- (id)initWithDictionary: (NSDictionary *)dict{
    self = [super init];
    self.exerciseName = dict[@"name"];
    self.numberReps = [NSNumber numberWithInt:0];
    self.numberSets = [NSNumber numberWithInt:0];
    self.lastWeight = [NSNumber numberWithInt:0];
    self.exerciseDescription = dict[@"description"];
    self.muscles = dict[@"muscles"];
    self.image = [PFFileObject fileObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.pinterest.com/pin/744923594593184616/"]]];
    self.user = [PFUser currentUser];
    return self;
}

+ (NSArray* )exercisesFromDictionaries: (NSArray* ) dictionary shouldSave:(BOOL)save{
    NSMutableArray *exercises = [[NSMutableArray alloc] init];
    for(NSDictionary* exercise in dictionary){
        Exercise *new = [[Exercise alloc] initWithDictionary:exercise];
        if(save){
            [Exercise saveExercise:new completionBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(error != nil){
                            NSLog(@"%@",error.localizedDescription);
                        }
            }];
        }
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

