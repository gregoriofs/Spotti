//
//  ExerciseListViewController.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN


@protocol choseExercise <NSObject>
- (void) addedNewExercise:(Exercise *)exercise;
@end

@interface ExerciseListViewController : UIViewController
@property (assign, nonatomic) BOOL addingExercise;
@property (strong, nonatomic) id<choseExercise> delegate;

@end

NS_ASSUME_NONNULL_END
