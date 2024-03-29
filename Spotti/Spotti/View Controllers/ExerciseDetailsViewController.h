//
//  ExerciseDetailsViewController.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN


@interface ExerciseDetailsViewController : UIViewController
@property (strong, nonatomic) Exercise *exercise;
@property (weak, nonatomic) IBOutlet UILabel *exerciseName;
@end

NS_ASSUME_NONNULL_END
