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
    self.freq = [NSNumber numberWithInt:1];
    NSLog(@"frequency: %d", [self.currentWorkout.frequency intValue]);
}

- (IBAction)didTapTwiceaWeek:(id)sender {
    self.freq = [NSNumber numberWithInt:2];
    NSLog(@"frequency: %d", [self.currentWorkout.frequency intValue]);
}

- (IBAction)didTapThriceaWeek:(id)sender {
    self.freq = [NSNumber numberWithInt:3];
    NSLog(@"frequency: %d", [self.currentWorkout.frequency intValue]);
}

- (IBAction)didTapFourTimes:(id)sender {
    self.freq = [NSNumber numberWithInt:4];
    NSLog(@"frequency: %d", [self.currentWorkout.frequency intValue]);
}

- (IBAction)didTapFinish:(id)sender {
    self.currentWorkout.frequency = self.freq;
    [self performSegueWithIdentifier:@"finishedSession" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nextViewController = [segue destinationViewController];
    WorkoutOverviewViewController *vc = (WorkoutOverviewViewController*)nextViewController.topViewController;
    vc.workout = self.currentWorkout;
    vc.fromList = NO;
}

@end
