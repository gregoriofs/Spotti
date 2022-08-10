//
//  MilestoneCreatorViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 8/5/22.
//

#import "MilestoneCreatorViewController.h"
#import "MKDropdownMenu/MKDropdownMenu.h"
#import "Exercise.h"
#import "ExerciseListViewController.h"
#import "APIManager.h"
#import "Milestone.h"


@interface MilestoneCreatorViewController () <MKDropdownMenuDelegate, MKDropdownMenuDataSource>
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropDown;
@property (weak, nonatomic) IBOutlet UITextField *repGoalInput;
@property (weak, nonatomic) IBOutlet UITextField *weightGoalInput;
@property (strong, nonatomic) NSArray *exercises;
@property (strong, nonatomic) Milestone *currentMilestone;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation MilestoneCreatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dropDown.dataSource = self;
    self.dropDown.delegate = self;
    self.saveButton.layer.cornerRadius = 5;
    self.currentMilestone = [[Milestone alloc] initWithValues];
    [self makeRequest:^(NSArray *result) {
        self.exercises = result;
        [self.dropDown reloadAllComponents];
    }];
}

- (BOOL)checkAnyEmpty{
    return [self.repGoalInput.text isEqualToString:@""] || [self.weightGoalInput.text isEqualToString:@""];
}

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu{
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component{
    return self.exercises.count;
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component{
    return 0;
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component{
    return 0;
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return ((Exercise *)self.exercises[row]).exerciseName;
}

- (void)makeRequest: (void (^)(NSArray *result))completion{
    APIManager *manager = [APIManager new];
    [manager exerciseList:-1 allExercises:YES completionBlock:^(NSArray * _Nonnull exercises) {
        completion(exercises);
    }];
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component{
    return self.currentMilestone.exercise ? self.currentMilestone.exercise.exerciseName : @"None";
}
- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.currentMilestone.exercise = self.exercises[row];
    [dropdownMenu reloadAllComponents];
}

- (IBAction)saveMilestone:(id)sender {
    if(![self checkAnyEmpty]){
        self.currentMilestone.repGoal = [NSNumber numberWithInt:[self.repGoalInput.text integerValue]];
        self.currentMilestone.weightGoal = [NSNumber numberWithInt:[self.weightGoalInput.text integerValue]];
        [self.currentMilestone saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded){
                        [self.delegate dismissMilestoneCreatorVC];
                    }
        }];
    }
}

@end
