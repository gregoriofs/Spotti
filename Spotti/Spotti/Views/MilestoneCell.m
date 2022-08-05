//
//  MilestoneCell.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 8/5/22.
//

#import "MilestoneCell.h"

@implementation MilestoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMilestone:(Milestone *)milestone{
    _milestone = milestone;
    _exerciseName.text = milestone.exercise.exerciseName;
    _currentReps.text = [NSString stringWithFormat:@"%d", [milestone.currentHighestReps intValue]];
    _currentWeight.text = [NSString stringWithFormat:@"%d", [milestone.currentHighestWeight intValue]];
    _repgoal.text = [NSString stringWithFormat:@"%d", [milestone.repGoal intValue]];
    _weightgoal.text = [NSString stringWithFormat:@"%d", [milestone.weightGoal intValue]];
    float weightProgress = (float)[milestone.currentHighestWeight intValue]/[milestone.weightGoal intValue];
    float repProgress = (float)[milestone.currentHighestReps intValue]/[milestone.repGoal intValue];
    [_weightProgressBar setProgress:weightProgress];
    [_weightProgressBar setProgressTintColor:[UIColor colorWithRed:0.0 green:weightProgress blue:0.0 alpha:1.0]];
    [_repProgressBar setProgress:repProgress];
    [_repProgressBar setProgressTintColor:[UIColor colorWithRed:0.0 green:repProgress blue:0.0 alpha:1.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
