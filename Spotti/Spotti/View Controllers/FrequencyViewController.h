//
//  FrequencyViewController.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "APIManager.h"
#include <stdlib.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrequencyViewController : UIViewController
@property (strong,nonatomic) Workout* currentWorkout;
@end

NS_ASSUME_NONNULL_END
