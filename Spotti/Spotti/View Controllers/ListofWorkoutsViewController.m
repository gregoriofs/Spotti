//
//  ListofWorkoutsViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/21/22.
//

#import "ListofWorkoutsViewController.h"
#import <Parse/Parse.h>
#import "WorkoutCell.h"
#import "Workout.h"
#import "WorkoutOverviewViewController.h"

@interface ListofWorkoutsViewController () <UITableViewDelegate, UITableViewDataSource, dismissVC>
@property (weak, nonatomic) IBOutlet UITableView *workouttableView;
@property (strong, nonatomic) NSArray *arrayOfWorkouts;
@end

@implementation ListofWorkoutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.workouttableView.delegate = self;
    self.workouttableView.dataSource = self;
    [self getWorkouts];
}

- (void)getWorkouts{
    PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
    GymUser *user = [[self.parentViewController restorationIdentifier] isEqualToString:@"homeVC"] ? [GymUser currentUser] : self.user;
    [query whereKey:@"user" equalTo:user];
    [query setLimit:5];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"%@", error.localizedDescription);
            }
            else{
                self.arrayOfWorkouts = objects;
                [self.workouttableView reloadData];
            }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell"];
    Workout *workout = self.arrayOfWorkouts[indexPath.row];
    cell.workout = workout;
    cell.complete.text = workout.completed ? @"Complete" : @"Incomplete";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormat stringFromDate:workout.createdAt];
    cell.createdAt.text = date;
    cell.workoutName.text = [NSString stringWithFormat:@"Workout: %@",[workout.focusAreas componentsJoinedByString:@","]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfWorkouts.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destination = [segue destinationViewController];
    WorkoutOverviewViewController *newVC = (WorkoutOverviewViewController *)destination.topViewController;
    newVC.workout = self.arrayOfWorkouts[[self.workouttableView indexPathForCell:sender].row];
    newVC.fromList = YES;
    newVC.delegate = self;
}

- (void)dismissWorkoutVC {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
