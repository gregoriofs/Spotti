//
//  Exercise.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Exercise : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *exerciseName;
@property (strong, nonatomic) NSNumber *numberSets;
@property (strong, nonatomic) NSNumber *numberReps;
@property (strong, nonatomic) NSString *exerciseDescription;
@property (strong, nonatomic) NSArray *muscles;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFFileObject *image;
@property (strong, nonatomic) NSNumber *lastWeight;
+ (NSArray* )exercisesFromDictionaries: (NSArray* ) dictionary shouldSave:(BOOL)save;
- (id)initWithDictionary: (NSDictionary *)dict;
+ (void)saveExercise:(Exercise *)exercise completionBlock: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
