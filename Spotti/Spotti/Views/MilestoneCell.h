//
//  MilestoneCell.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 8/5/22.
//

#import <UIKit/UIKit.h>
#import "Milestone.h"

NS_ASSUME_NONNULL_BEGIN

@interface MilestoneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *exerciseName;
@property (weak, nonatomic) IBOutlet UILabel *currentReps;
@property (weak, nonatomic) IBOutlet UILabel *currentWeight;
@property (weak, nonatomic) IBOutlet UILabel *repgoal;
@property (weak, nonatomic) IBOutlet UILabel *weightgoal;
@property (weak, nonatomic) IBOutlet UIProgressView *repProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *weightProgressBar;
@property (strong, nonatomic) Milestone *milestone;
@end

NS_ASSUME_NONNULL_END
