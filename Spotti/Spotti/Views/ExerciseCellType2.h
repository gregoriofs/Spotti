//
//  ExerciseCellType2.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "ExerciseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseCellType2 : ExerciseCell
@property (weak, nonatomic) IBOutlet UILabel *numReps;
@property (weak, nonatomic) IBOutlet UILabel *numSets;
@end

NS_ASSUME_NONNULL_END
