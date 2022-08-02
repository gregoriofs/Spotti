//
//  WorkoutCell.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/14/22.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *workoutName;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *complete;
@property (strong, nonatomic) Workout *workout;
@end

NS_ASSUME_NONNULL_END
