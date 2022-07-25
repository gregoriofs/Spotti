//
//  ExerciseListCell.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *exerciseName;
@property (weak, nonatomic) IBOutlet UILabel *focusArea;
@property (strong, nonatomic) Exercise *exercise;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

NS_ASSUME_NONNULL_END
