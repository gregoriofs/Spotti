//
//  FrequencyViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "FrequencyViewController.h"
#import "Exercise.h"
#import "WorkoutOverviewViewController.h"

@interface FrequencyViewController ()
@property (strong, nonatomic) NSNumber *freq;
@end

@implementation FrequencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapOnceaWeek:(id)sender {
    self.currentWorkout.frequency = [NSNumber numberWithInt:1];
    [self performSegueWithIdentifier:@"finishedSession" sender:nil];
}

- (IBAction)didTapTwiceaWeek:(id)sender {
    self.currentWorkout.frequency = [NSNumber numberWithInt:2];
    [self performSegueWithIdentifier:@"finishedSession" sender:nil];
}

- (IBAction)didTapThriceaWeek:(id)sender {
    self.currentWorkout.frequency = [NSNumber numberWithInt:3];
    [self performSegueWithIdentifier:@"finishedSession" sender:nil];
}

- (IBAction)didTapFourTimes:(id)sender {
    self.currentWorkout.frequency = [NSNumber numberWithInt:4];
    [self performSegueWithIdentifier:@"finishedSession" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nextViewController = [segue destinationViewController];
    WorkoutOverviewViewController *vc = (WorkoutOverviewViewController*)nextViewController.topViewController;
    vc.workout = self.currentWorkout;
    vc.fromList = NO;
}

@end
