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
    
    
    
    [self fillExerciseList];
    
}

- (void)fillExerciseList{
    
    APIManager *manager = [APIManager new];
    
    [manager exerciseListFromWorkout:self.workout currentExercise:1 completionBlock:^(NSArray *exercises){
        self.workout.exerciseArray = exercises;
        [self.tableView reloadData];
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
    
    Exercise *currentExercise = [[Exercise alloc] initWithDictionary:self.workout.exerciseArray[indexPath.row]];
    
    cell.exercise = currentExercise;
    cell.exerciseName.text = currentExercise.exerciseName;
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"number of counts %lu", (unsigned long)self.exercises.count);
    return self.workout.exerciseArray.count;
}

- (BOOL)checkEmptyInputs{
    
    for(int i = 0; i < self.workout.exerciseArray.count;i++){
        NSIndexPath *currPath = [NSIndexPath indexPathForRow:i inSection:0];
        ExerciseCell *cell = [self.tableView cellForRowAtIndexPath: currPath];
        if([cell.repsInput.text isEqualToString:@""] || [cell.setsInput.text isEqualToString:@""]){
            NSLog(@"empty rep input/set input for cell %ld", (long)currPath.row);
            return YES;
        }
    }
    
    return NO;
}
- (IBAction)didTapHome:(id)sender {
    
    if([self checkEmptyInputs]){
        
    }
    
}

- (IBAction)didTapFinishWorkout:(id)sender {
    
    //TODO: add popup in the case where reps or sets aren't all filled for an exercise telling them to complete workout before saving
    
    if([self checkEmptyInputs]){
//        NSLog(@"empty rep input/set input for a cell");
    }
    
    NSLog(@"no empty inputs");
    
    [Workout postWorkout:self.workout completionBlock:^(BOOL succeeded, NSError* error){
        if(succeeded){
            NSLog(@"succesfully saved the workout");
            
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

@end
