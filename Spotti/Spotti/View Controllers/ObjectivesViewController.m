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
@property (weak, nonatomic) IBOutlet UIButton *strength;
@property (weak, nonatomic) IBOutlet UIButton *conditioning;
@property (weak, nonatomic) IBOutlet UIButton *muscleGrowth;
@property (weak, nonatomic) IBOutlet UIButton *fitness;

@end

@implementation ObjectivesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentWorkout = [Workout new];
    self.currentWorkout.createdAt = [NSDate date];
    self.currentWorkout.completed = [NSNumber numberWithBool:NO];
    self.currentWorkout.user = [GymUser currentUser];
    [self formatButton:self.strength];
    [self formatButton:self.conditioning];
    [self formatButton:self.fitness];
    [self formatButton:self.muscleGrowth];
}

- (void)formatButton: (UIButton *)button {
    button.layer.shadowColor = [[UIColor grayColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(0, 5.0);
    button.layer.shadowRadius = 5;
    button.layer.shadowOpacity = 1.0;
    button.layer.cornerRadius = 5;
}

- (IBAction)didTapStrength:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    [sender setHighlighted:YES];
    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
}

- (IBAction)didTapConditioning:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    [sender setHighlighted:YES];
    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
}

- (IBAction)didTapMuscleGrowth:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    [sender setHighlighted:YES];
    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
}

- (IBAction)didTapFitness:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    [sender setHighlighted:YES];
    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Potential error: not selecting the navigation controller, just the focus vc so it won't properly update or something similar
    UINavigationController *navigationController = [segue destinationViewController];
    FocusAreaViewController *newVC = (FocusAreaViewController *)navigationController.topViewController;
    newVC.currentWorkout = self.currentWorkout;
}

@end
