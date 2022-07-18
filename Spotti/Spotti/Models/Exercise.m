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
    self.numberReps = [NSNumber numberWithInt:0];
    self.numberSets = [NSNumber numberWithInt:0];
    self.exerciseDescription = dict[@"description"];
    self.muscles = dict[@"muscles"];
    self.image = [PFFileObject fileObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://media1.popsugar-assets.com/files/thumbor/oStCU38qB6hu1AHCJ5CyLBQ6TAY/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2019/02/27/986/n/1922729/6982a2275c7711f34ee2e8.35687035_/i/Why-Women-Work-Out.jpg"]]];
    self.user = [PFUser currentUser];
    return self;
}

+ (NSArray* )exercisesFromDictionaries: (NSArray* ) dictionary{
    NSMutableArray *exercises = [[NSMutableArray alloc] init];
    for(NSDictionary* exercise in dictionary){
        Exercise *new = [[Exercise alloc] initWithDictionary:exercise];
        [Exercise saveExercise:new completionBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error != nil){
                        NSLog(@"%@",error.localizedDescription);
                    }
        }];
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

