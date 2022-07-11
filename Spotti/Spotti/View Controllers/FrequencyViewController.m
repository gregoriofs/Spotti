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

@property (strong, nonatomic) NSMutableArray *exerciseList;

@end

@implementation FrequencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exerciseList = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}
- (IBAction)didTapOnceaWeek:(id)sender {
    self.currentWorkout.frequency = [NSNumber numberWithInt:1];
}
- (IBAction)didTapTwiceaWeek:(id)sender {
    
    self.currentWorkout.frequency = [NSNumber numberWithInt:2];
    
}
- (IBAction)didTapThriceaWeek:(id)sender {
    
    self.currentWorkout.frequency = [NSNumber numberWithInt:3];
    
}
- (IBAction)didTapFourTimes:(id)sender {
    
    self.currentWorkout.frequency = [NSNumber numberWithInt:4];
    
}
- (IBAction)didTapFinish:(id)sender {
    
    [self performSegueWithIdentifier:@"finishedSession" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *nextViewController = [segue destinationViewController];
    WorkoutOverviewViewController *vc = (WorkoutOverviewViewController*)nextViewController.topViewController;
    vc.workout = self.currentWorkout;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

*/

@end
