//
//  WorkoutOverviewViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/8/22.
//


//TODO: Upon finishing a workout, save exercises and their values to parse saveinBackgroundwithBlock


#import "WorkoutOverviewViewController.h"
#import "ExerciseCell.h"
#import "ExerciseCellType2.h"
#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "ExerciseDetailsViewController.h"
#import "GymUser.h"
#import "ProfileViewController.h"
#import "ExerciseListViewController.h"
#import "Milestone.h"

@interface WorkoutOverviewViewController () <UITableViewDelegate,UITableViewDataSource, UITabBarDelegate, choseExercise>
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
    self.frequency.text = [NSString stringWithFormat:@"%d times a week", [self.workout.frequency intValue]];
    if(!self.fromList){
        [self fillExerciseList];
    }
}

- (void)fillExerciseList{
    APIManager *manager = [APIManager new];
    [manager exerciseListFromWorkout:self.workout currentExercise:1 completionBlock:^(NSArray *exercises){
        if(!self.fromList){
            self.workout.exerciseArray = [Exercise exercisesFromDictionaries:exercises shouldSave:YES];
        }
        else {
            self.workout.exerciseArray = [Exercise exercisesFromDictionaries:exercises shouldSave:NO];
        }
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"detailSegue"]){
        NSIndexPath *currPath = [self.tableView indexPathForCell:sender];
        Exercise *currExercise = self.workout.exerciseArray[currPath.row];
        ExerciseDetailsViewController *next = [segue destinationViewController];
        next.transitioningDelegate = self;
        next.exercise = currExercise;
    }
    else if([[segue identifier] isEqualToString:@"addingExercise"]){
        ExerciseListViewController* next = [segue destinationViewController];
        next.addingExercise = YES;
        next.delegate = self;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Exercise *currentExercise = self.workout.exerciseArray[indexPath.row];
    [currentExercise fetchIfNeeded];
    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell" forIndexPath:indexPath];
    if(([currentExercise.numberSets intValue] != 0) || ![self.workout.user.objectId isEqualToString:[GymUser currentUser].objectId]){
        ExerciseCellType2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCellV2"];
        [cell2 setExercise:currentExercise];
        [cell2.exerciseName sizeToFit];
        return cell2;
    }
    [cell setExercise:currentExercise];
    [cell.exerciseName sizeToFit];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workout.exerciseArray.count;
}

- (BOOL)checkEmptyInputs{
    for(int i = 0; i < self.workout.exerciseArray.count;i++){
        NSIndexPath *currPath = [NSIndexPath indexPathForRow:i inSection:0];
        ExerciseCell *cell = [self.tableView cellForRowAtIndexPath: currPath];
        if([[cell reuseIdentifier] isEqual:@"ExerciseCell"]){
            if([cell.repsInput.text isEqualToString:@""] || [cell.setsInput.text isEqualToString:@""] || [cell.weightInput.text isEqualToString: @""]){
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)checkPairsNotComplete{
    for(int i = 0; i < self.workout.exerciseArray.count;i++){
        NSIndexPath *currPath = [NSIndexPath indexPathForRow:i inSection:0];
        ExerciseCell *cell = [self.tableView cellForRowAtIndexPath: currPath];
        if([[cell reuseIdentifier] isEqual:@"ExerciseCell"]){
            int complete = 0;
            if(![cell.repsInput.text isEqualToString:@""]){
                complete += 1;
            }
            if(![cell.setsInput.text isEqualToString:@""]){
                complete += 1;
            }
            if(![cell.weightInput.text isEqualToString:@""]){
                complete += 1;
            }
            if(complete != 3 && complete != 0){
                return YES;
            }
        }
    }
    return NO;
}

- (IBAction)didTapHome:(id)sender {
    //TODO: Reminder that workout is not complete and can be finished later
    if(![self checkPairsNotComplete]){
        [self saveWorkoutAndReturnHome];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Sets/Reps/Exercise" message:@"Please fill out all the metrics for an exercise before saving!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Go Back" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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

- (void)checkMilestonesAndUpdate{
    PFQuery *query = [PFQuery queryWithClassName:@"Milestone"];
    [query whereKey:@"user" equalTo:[GymUser currentUser]];
    [query whereKey:@"inProgress" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            for(Milestone* milestone in objects){
                [milestone update:self.workout];
            }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"load" object:nil];
    }];
    
}

- (void)saveWorkoutAndReturnHome{
    for(int i = 0; i < self.workout.exerciseArray.count;i++){
        ExerciseCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        NSNumber *repsValid = [formatter numberFromString:cell.repsInput.text];
        NSNumber *setsValid = [formatter numberFromString:cell.setsInput.text];
        NSNumber *weightValid = [formatter numberFromString:cell.weightInput.text];
        if(![cell.repsInput.text isEqualToString:@""] && repsValid && setsValid && weightValid){
            cell.exercise.numberSets = setsValid;
            cell.exercise.numberReps = repsValid;
            cell.exercise.lastWeight = weightValid;
            [cell.exercise saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error != nil){
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
    }
    [self checkMilestonesAndUpdate];
    [Workout postWorkout:self.workout completionBlock:^(BOOL succeeded, NSError* error){
        if(succeeded){
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if(!self.fromList){
                HomeViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
                myDelegate.window.rootViewController = home;
            }
            else{
                [self.delegate dismissWorkoutVC];
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)updateStreak{
    GymUser *currentUser = [GymUser currentUser];
    if([[NSDate date] timeIntervalSinceDate:currentUser.lastWorkout] < 82400){
        [currentUser incrementKey:@"streak"];
    }
    else {
        [currentUser setObject:[NSNumber numberWithInt:0] forKey:@"streak"];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)addedNewExercise:(Exercise *)exercise{
    NSMutableArray *temp = [self.workout.exerciseArray mutableCopy];
    [temp addObject:exercise];
    self.workout.exerciseArray = [temp copy];
    [self.workout setObject:[temp copy] forKey:@"exerciseArray"];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
