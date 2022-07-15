//
//  WorkoutOverviewViewController.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutOverviewViewController : UIViewController
@property (strong, nonatomic) Workout *workout;
@property (strong, nonatomic) NSArray __block *exercises;
@property (assign, nonatomic) BOOL fromList;
@end

NS_ASSUME_NONNULL_END
