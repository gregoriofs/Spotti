//
//  ExerciseCell.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseCell : UITableViewCell

@property (strong, nonatomic) Exercise* exercise;
@property (weak, nonatomic) IBOutlet UITextField *repsInput;
@property (weak, nonatomic) IBOutlet UITextField *setsInput;
@property (weak, nonatomic) IBOutlet UILabel *exerciseName;
@property (weak, nonatomic) IBOutlet UITextField *weightInput;

@end

NS_ASSUME_NONNULL_END
