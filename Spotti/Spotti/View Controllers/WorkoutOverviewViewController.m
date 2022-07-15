//
//  WorkoutOverviewViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/8/22.
//


//TODO: Upon finishing a workout, save exercises and their values to parse saveinBackgroundwithBlock


#import "WorkoutOverviewViewController.h"
#import "ExerciseCell.h"
#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "ExerciseDetailsViewController.h"
#import "GymUser.h"

@interface WorkoutOverviewViewController () <UITableViewDelegate,UITableViewDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *objectives;
@property (weak, nonatomic) IBOutlet UILabel *focusAreas;
@property (weak, nonatomic) IBOutlet UILabel *frequency;
@end

@implementation WorkoutOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.objectives.text = self.workout.objective;
    self.focusAreas.text = [self.workout.focusAreas componentsJoinedByString:@","];
    self.frequency.text = [NSString stringWithFormat:@"%@ times a week", self.workout.frequency];
    if(!self.fromList){
        [self fillExerciseList];
    }
}

- (void)fillExerciseList{
    APIManager *manager = [APIManager new];
    [manager exerciseListFromWorkout:self.workout currentExercise:1 completionBlock:^(NSArray *exercises){
        self.workout.exerciseArray = exercises;
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"detailSegue"]){
        NSIndexPath *currPath = [self.tableView indexPathForCell:sender];
        NSDictionary *currExercise = self.workout.exerciseArray[currPath.row];
        ExerciseDetailsViewController *next = [segue destinationViewController];
        next.exercise = [[Exercise alloc] initWithDictionary:currExercise];
        APIManager *new = [APIManager new];
        [new getImage: currExercise[@"id"] completionBlock:^(NSURL *url){
            next.imageURL  = url;
        }];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
    Exercise *currentExercise = [[Exercise alloc] initWithDictionary:self.workout.exerciseArray[indexPath.row]];
    cell.exercise = currentExercise;
    cell.exerciseName.text = currentExercise.exerciseName;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workout.exerciseArray.count;
}

- (BOOL)checkEmptyInputs{
    for(int i = 0; i < self.workout.exerciseArray.count;i++){
        NSIndexPath *currPath = [NSIndexPath indexPathForRow:i inSection:0];
        ExerciseCell *cell = [self.tableView cellForRowAtIndexPath: currPath];
        if([cell.repsInput.text isEqualToString:@""] || [cell.setsInput.text isEqualToString:@""]){
            return YES;
        }
    }
    return NO;
}

- (IBAction)didTapHome:(id)sender {
    //TODO: Reminder that workout is not complete and can be finished later
    [self saveWorkoutAndReturnHome];
}

- (IBAction)didTapFinishWorkout:(id)sender {
    //TODO: add popup in the case where reps or sets aren't all filled for an exercise telling them to complete workout before saving
    //TODO: figure out how to save things continuously for progress and also saving exercises to users so their stats can be accessed later in profile
    
    if(![self checkEmptyInputs]){
        self.workout.completed = [NSNumber numberWithBool:YES];
        GymUser *currentUser = [GymUser currentUser];
        currentUser.lastWorkout = [NSDate date];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
            if(error != nil){
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updateStreak];
        [self saveWorkoutAndReturnHome];
    }
}

- (void)saveWorkoutAndReturnHome{
    [Workout postWorkout:self.workout completionBlock:^(BOOL succeeded, NSError* error){
        if(succeeded){
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
            myDelegate.window.rootViewController = home;
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)updateStreak{
    GymUser *currentUser = [GymUser currentUser];
    
    if([[NSDate date] timeIntervalSinceDate:currentUser.lastWorkout] < 82400){
        [currentUser incrementKey:@"streak"];
    }
    else{
        [currentUser setObject:[NSNumber numberWithInt:0] forKey:@"streak"];
    }
}

@end
