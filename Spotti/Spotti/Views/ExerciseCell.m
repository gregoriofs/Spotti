//
//  ExerciseCell.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/8/22.
//

#import "ExerciseCell.h"

@implementation ExerciseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setExercise:(Exercise *)exercise{
    _exercise = exercise;
    _exerciseName.text = exercise.exerciseName;
}


@end
