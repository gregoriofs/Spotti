//
//  APIManager.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "APIManager.h"
#import "Workout.h"


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

- (void)exerciseListFromWorkout:(Workout*) workout currentExercise:(int) current completionBlock:(void(^)(NSArray *exercise))completion{
    
    //TODO: Unhard code focus areas
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://wger.de",@"/api/v2/exercise/?limit=200&language=2"]];
    //    NSLog(@"%@",url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                
                            NSLog(@"%@", [error localizedDescription]);
                
                        }
            else
            {
                NSLog(@"Succesful results");
            
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSArray *results = dataDictionary[@"results"];
                NSLog(@"werwr %@",results);
                
                int totalExercises = [workout.frequency intValue] >= 3 ? 6 : 8;
                
                int numExercisesPerArea = totalExercises/(workout.focusAreas.count);
                
                NSLog(@"frequency %d, numexercisesperarea %lu", [workout.frequency intValue], (unsigned long)workout.focusAreas.count);
//                NSLog(@"gsjlag %@, jsfsdf %@", [self.muscleNumbers[@"Triceps"][0] class], [results[4][@"muscles"][0] class]);
                
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
                    
                    NSLog(@"currentnumbers %@ ,filtered Array %@, results count: %lu",currentExerciseNumbers, filteredArray, (unsigned long)results.count);
                    
                    for(int j = 0; j < numExercisesPerArea;j++){
                        int randomExercise = arc4random_uniform(filteredArray.count);
                        [exercises addObject:filteredArray[randomExercise]];
                    }
                    
                }
                
                completion([exercises copy]);
                
            }
        }];
    
    [task resume];
//        }
    
    //TODO: figure out why the exercises aren't being saved in the array
    /*Tried: dispatch groups
            adding property to view controller to store exercises
            console logging at different steps
     
     conclusion: once i exit completion handler for task, nothing is being saved to the array outside even though within the handler, the array grows
*/
}
@end
