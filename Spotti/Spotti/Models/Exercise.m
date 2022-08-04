//
//  Exercise.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "Exercise.h"
#import "APIManager.h"

@implementation Exercise

@dynamic exerciseName;
@dynamic numberSets;
@dynamic numberReps;
@dynamic exerciseDescription;
@dynamic muscles;
@dynamic user;
@dynamic image;
@dynamic lastWeight;
@dynamic apiId;

- (id)initWithDictionary: (NSDictionary *)dict image:(NSURL *)url{
    self = [super init];
    self.exerciseName = dict[@"name"];
    self.numberReps = [NSNumber numberWithInt:0];
    self.numberSets = [NSNumber numberWithInt:0];
    self.lastWeight = [NSNumber numberWithInt:0];
    self.exerciseDescription = dict[@"description"];
    self.muscles = dict[@"muscles"];
    self.image = [PFFileObject fileObjectWithData:[NSData dataWithContentsOfURL:url]];
    self.user = [PFUser currentUser];
    self.apiId = dict[@"id"];
    return self;
}

+ (NSArray* )exercisesFromDictionaries: (NSArray* ) dictionary shouldSave:(BOOL)save{
    NSMutableArray *exercises = [[NSMutableArray alloc] init];
    APIManager *manager = [APIManager new];
    for(NSDictionary* exercise in dictionary){
        __block NSURL *actualUrl = [NSURL URLWithString:@"https://shirtigo.co/wp-content/uploads/2015/01/weightliftingaccident.jpg"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [manager getImage:exercise[@"id"] completionBlock:^(NSURL * _Nonnull url) {
                actualUrl = url;
            }];
        });
        Exercise *new = [[Exercise alloc] initWithDictionary:exercise image:actualUrl];
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

