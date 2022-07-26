//
//  ObjectivesViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "ObjectivesViewController.h"
#import "FocusAreaViewController.h"
#import "GymUser.h"

@interface ObjectivesViewController ()

@end

@implementation ObjectivesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentWorkout = [Workout new];
    self.currentWorkout.createdAt = [NSDate date];
    self.currentWorkout.completed = [NSNumber numberWithBool:NO];
    self.currentWorkout.user = [GymUser currentUser];
}

- (IBAction)didTapStrength:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
}

- (IBAction)didTapConditioning:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
}

- (IBAction)didTapMuscleGrowth:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
}

- (IBAction)didTapFitness:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
}
//
//- (IBAction)didTapNext:(id)sender {
//    if(self.currentWorkout.objective != nil){
//
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Potential error: not selecting the navigation controller, just the focus vc so it won't properly update or something similar
    UINavigationController *navigationController = [segue destinationViewController];
    FocusAreaViewController *newVC = (FocusAreaViewController *)navigationController.topViewController;
    newVC.currentWorkout = self.currentWorkout;
}

@end
