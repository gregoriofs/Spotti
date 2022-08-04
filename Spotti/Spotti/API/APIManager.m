//
//  APIManager.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "APIManager.h"
#import "Workout.h"
#import "Exercise.h"
#import <Parse/Parse.h>

static NSString * const baseURLString = @"https://wger.de";

@implementation APIManager

- (instancetype)init {
    self = [super init];
    NSMutableDictionary *muscleNumbers = [[NSMutableDictionary alloc] init];
    muscleNumbers[@"Legs"] = [NSArray arrayWithObjects:[NSNumber numberWithInt:(11)],[NSNumber numberWithInt:(7)],[NSNumber numberWithInt:(8)],[NSNumber numberWithInt:(10)],[NSNumber numberWithInt:(3)],[NSNumber numberWithInt:(15)],  nil];
    muscleNumbers[@"Chest"] = [NSArray arrayWithObjects:[NSNumber numberWithInt:(4)], nil];
    muscleNumbers[@"Back"] = [NSArray arrayWithObjects:[NSNumber numberWithInt:(12)], [NSNumber numberWithInt:(9)],nil];
    muscleNumbers[@"Biceps"] = [NSArray arrayWithObjects:[NSNumber numberWithInt:(1)],[NSNumber numberWithInt:(13)], nil];
    muscleNumbers[@"Triceps"] = [NSArray arrayWithObjects:[NSNumber numberWithInt:(5)], nil];
    muscleNumbers[@"Shoulders"] = [NSArray arrayWithObjects:[NSNumber numberWithInt:(2)], nil];
    self.muscleNumbers = [muscleNumbers copy];
    self.session = [NSURLSession sharedSession];
    return self;
}

- (void)exerciseList:(NSInteger)currentOffset allExercises:(BOOL)all completionBlock:(void(^)(NSArray *exercises))completion{
    if (!all){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld",@"https://wger.de",@"/api/v2/exercise/?limit=20&language=2&offset=",(long)currentOffset]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            NSURLSession *session =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if(error != nil){
                    NSLog(@"%@", [error localizedDescription]);
                }
                else
                {
                    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSArray *results = [Exercise exercisesFromDictionaries:dataDictionary[@"results"] shouldSave:NO];
                    completion(results);
                }
            }];
        [task resume];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query whereKey:@"user" equalTo:[GymUser currentUser]];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            completion(objects);
        }
    }];
}



- (void)exerciseListFromWorkout:(Workout*) workout currentExercise:(int) current completionBlock:(void(^)(NSArray *exercise))completion{
    //TODO: Get image for the exercise base if possible, might have to make two api queries simultaneously
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://wger.de",@"/api/v2/exercise/?limit=200&language=2"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error != nil){
                NSLog(@"%@", [error localizedDescription]);
            }
            else
            {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSArray *results = dataDictionary[@"results"];
                int totalExercises = [workout.frequency intValue] >= 3 ? 6 : 8;
                int numExercisesPerArea = totalExercises/(workout.focusAreas.count);
                NSMutableArray *exercises = [NSMutableArray new];
                for(int i = 0; i < workout.focusAreas.count; i++){
                    NSArray *currentExerciseNumbers = self.muscleNumbers[workout.focusAreas[i]];
                    NSArray *filteredArray = [results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* binding){
                        for(NSNumber* num in evaluatedObject[@"muscles"]){
                            if([currentExerciseNumbers containsObject:num]){
                                return YES;
                            }
                        }
                        return NO;
                    }]];
                    for(int j = 0; j < numExercisesPerArea;j++){
                        int randomExercise = arc4random_uniform(filteredArray.count);
                        [exercises addObject:filteredArray[randomExercise]];
                    }
                }
                completion([exercises copy]);
            }
        }];
    [task resume];
}


-(void)getImage:(NSNumber *)exerciseNum completionBlock:(void (^)(NSURL * _Nonnull))completion{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%d",@"https://wger.de",@"/api/v2/exerciseimage/",[exerciseNum intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSURL *image = dataDictionary[@"image"];
            if(image == nil){
                completion([NSURL URLWithString:@"https://shirtigo.co/wp-content/uploads/2015/01/weightliftingaccident.jpg"]);
            }
            completion(image);
        }
    }];
    [task resume];
}

@end
