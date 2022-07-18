//
//  GymUser.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface GymUser : PFUser

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lasttName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSNumber *weight;
@property (strong, nonatomic) NSString *fitnessLevel;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) PFFileObject *profilePic;
@property (strong, nonatomic) NSDate *lastWorkout;
@property (strong, nonatomic) NSNumber *streak;
@property (strong, nonatomic) NSString *gym;

@end

NS_ASSUME_NONNULL_END
