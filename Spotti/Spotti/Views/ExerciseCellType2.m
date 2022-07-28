//
//  ExerciseCellType2.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/15/22.
//

#import "ExerciseCellType2.h"

@implementation ExerciseCellType2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setExercise:(Exercise *)exercise{
    [super setExercise:exercise];
    _numReps.text = [NSString stringWithFormat:@"%d", [exercise.numberReps intValue]];
    _numSets.text = [NSString stringWithFormat:@"%d", [exercise.numberSets intValue]];
    _weightAmount.text = [NSString stringWithFormat:@"%d", [exercise.lastWeight intValue]];

}

@end
