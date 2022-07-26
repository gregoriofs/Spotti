//
//  APIManager.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import <Foundation/Foundation.h>
#import "Workout.h"
NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSDictionary *muscleNumbers;
- (void)exerciseListFromWorkout:(Workout*) workout currentExercise:(int) current completionBlock:(void(^)(NSArray* exercise))completion;
-(void)getImage:(id)exerciseNum completionBlock:(void (^)(NSURL* url))completion;
- (void)exerciseList:(NSInteger)numberofExercises completionBlock:(void(^)(NSArray *exercises))completion;
@end

NS_ASSUME_NONNULL_END
