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

@protocol dismissVC <NSObject>

- (void)dismissWorkoutVC;

@end

@interface WorkoutOverviewViewController : UIViewController <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) Workout *workout;
@property (strong, nonatomic) NSArray __block *exercises;
@property (assign, nonatomic) BOOL fromList;
@property (weak, nonatomic) id<dismissVC> delegate;
@end

NS_ASSUME_NONNULL_END
