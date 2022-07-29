//
//  ExerciseDetailSegue.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/28/22.
//

#import "ExerciseDetailSegue.h"
#import "WorkoutOverviewViewController.h"
#import "ExerciseDetailsViewController.h"


@implementation ExerciseDetailSegue 

- (void)perform{
    
    [self scale];
    
//
//    UIViewController *destination = self.destinationViewController;
//    UIViewController *source = self.sourceViewController;
//
//    UIViewController *container = source.view.superview;
//    UIViewController *originalCenter
    
}

-(void)scale{
    ExerciseDetailsViewController *destination = self.destinationViewController;
    WorkoutOverviewViewController *from = self.sourceViewController;
    
    UIView *containerView = from.view.superview;
    CGPoint originalCenter = from.view.center;
    
    destination.view.transform = CGAffineTransformMakeScale(.05, .05);
    destination.view.center = originalCenter;
    
    [containerView addSubview:destination.view];
    
    [UIView animateWithDuration:.5 animations:^{
        destination.view.transform = CGAffineTransformIdentity;
        [from presentViewController:destination animated:false completion:nil];
    }];
}

@end
