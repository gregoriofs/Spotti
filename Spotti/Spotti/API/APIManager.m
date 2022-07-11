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
    muscleNumbers[@"Legs"] = [NSArray arrayWithObjects:@(11),@(7),@(8),@(10),@(3),@(15),  nil];
    muscleNumbers[@"Chest"] = [NSArray arrayWithObjects:@(4), nil];
    muscleNumbers[@"Back"] = [NSArray arrayWithObjects:@(12), @(9),nil];
    muscleNumbers[@"Biceps"] = [NSArray arrayWithObjects:@(1),@(13), nil];
    muscleNumbers[@"Triceps"] = [NSArray arrayWithObjects:@(5), nil];
    muscleNumbers[@"Shoulders"] = [NSArray arrayWithObjects:@(2), nil];
    
    self.muscleNumbers = [muscleNumbers copy];
    
    self.session = [NSURLSession sharedSession];

    return self;
}

- (void)exerciseListFromWorkout:(Workout*) workout currentExercise:(int) current completionBlock:(void(^)(NSArray *exercise))completion{
    
    //TODO: Unhard code focus areas
    
    NSArray *focusAreas = workout.focusAreas;
    
    int numberOfExercises = [workout.frequency intValue] >= 3 ? 7 : 5;
    int exercisesPerArea = (numberOfExercises/focusAreas.count) + 1;
    
    NSString *area = focusAreas[current];
    
//        for(NSString *area in focusAreas){
            
            NSMutableArray *exerciseArray = [[NSMutableArray alloc] init];
            
            NSString *currentExerciseNumbers = [[self.muscleNumbers[area] valueForKey:@"description"] componentsJoinedByString:@","];
        
            NSLog(@"%@", currentExerciseNumbers);
        
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@/",baseURLString,@"/api/v2/exercise/?language=2&muscles=",currentExerciseNumbers]];
//            NSLog(@"%@",url);
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            
            NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"executing task");
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else {
                        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        NSArray *results = dataDictionary[@"results"];
                        
//                        NSLog(@"Results size %lu", (unsigned long)results.count);
//                        for(int i= 0; i < exercisesPerArea;i++){
//                            NSLog(@"exercises per area: %d",exercisesPerArea);
//
//                            int r = arc4random_uniform(results.count);
//
//                            [exerciseArray addObject:results[r]];
//                        }
                        
                        completion(results);
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
