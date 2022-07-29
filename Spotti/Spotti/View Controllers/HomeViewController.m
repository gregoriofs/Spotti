//
//  HomeViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/6/22.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "APIManager.h"
#import "UserNotifications/UserNotifications.h"
#import "GymUser.h"
#import "ProfileViewController.h"
#import "MKDropdownMenu.h"
#import "Exercise.h"

@interface HomeViewController () <UNUserNotificationCenterDelegate, UITabBarControllerDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate>

@property (strong, nonatomic) UNUserNotificationCenter *center;
@property (weak, nonatomic) IBOutlet UIButton *createSessionButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendsButton;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *exerciseListButton;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) NSArray *exercise1;
@property (strong, nonatomic) NSArray *exercise2;
@property (strong, nonatomic) NSArray *exercise3;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) NSArray *exercises;
@end

@implementation HomeViewController

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionSound);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.center = [UNUserNotificationCenter currentNotificationCenter];
    [self.center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
      if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
          self.hasNotificationPermission = NO;
      }
      else{
          self.hasNotificationPermission = YES;
      }
    }];
    APIManager *manager = [APIManager new];
    [manager exerciseList:1 allExercises:YES completionBlock:^(NSArray * _Nonnull exercises) {
        self.exercises = exercises;
        dispatch_async(dispatch_get_main_queue(), ^{
            for(int i = 0; i < 3; i++){
                NSMutableArray *children = [NSMutableArray new];
                for(Exercise *exercise in exercises){
                    UIAction *act = nil;
                    if(i == 0){
                        act = [UIAction actionWithTitle:exercise.exerciseName image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [self getMostRecentExercise:exercise.exerciseName completionBlock:^(NSArray *exercises) {
                                                            self.exercise1 = exercises;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self setUpStackView:i];
                                });
                            }];
                        }];
                    }
                    else if(i == 1){
                        act = [UIAction actionWithTitle:exercise.exerciseName image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [self getMostRecentExercise:exercise.exerciseName completionBlock:^(NSArray *exercises) {
                                                            self.exercise2 = exercises;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self setUpStackView:i];
                                });
                            }];
                        }];
                    }
                    else{
                        act = [UIAction actionWithTitle:exercise.exerciseName image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [self getMostRecentExercise:exercise.exerciseName completionBlock:^(NSArray *exercises) {
                                                            self.exercise3 = exercises;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self setUpStackView:i];
                                });
                            }];
                        }];
                    }
                    [children addObject:act];
                }
                UIMenu *menu = [UIMenu menuWithChildren:[children copy]];
                if(i == 0){
                    [self.button setMenu:menu];
                    [self.button setShowsMenuAsPrimaryAction:true];
                }
                else if(i == 1){
                    [self.button2 setMenu:menu];
                    [self.button2 setShowsMenuAsPrimaryAction:true];
                }
                else if(i == 2){
                    [self.button3 setMenu:menu];
                    [self.button3 setShowsMenuAsPrimaryAction:true];
                }
            }
        });
    }];
    [self setUpStackView:1];
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.spacing = 5.0;
    self.center.delegate = self;
    self.createSessionButton.layer.cornerRadius = 5;
    self.addFriendsButton.layer.cornerRadius = 5;
    self.exerciseListButton.layer.cornerRadius = 5;
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@!", [GymUser currentUser].username];
}

- (void)setUpStackView:(NSInteger)indexToInsert{
    if(self.stackView.arrangedSubviews.count == 0){
        [self.stackView addArrangedSubview:[self makeViewforStackView:nil]];
        [self.stackView addArrangedSubview:[self makeViewforStackView:nil]];
        [self.stackView addArrangedSubview:[self makeViewforStackView:nil]];
    }
    else{
        UIView *newView = [self makeViewforStackView:self.exercise1[0]];;
        if(indexToInsert == 1){
            newView = [self makeViewforStackView:self.exercise2[0]];
        }
        else if (indexToInsert == 2){
            newView = [self makeViewforStackView:self.exercise3[0]];
        }
        [self.stackView.arrangedSubviews[indexToInsert] removeFromSuperview];
        [self.stackView insertArrangedSubview:newView atIndex:indexToInsert];
    }
}

- (UIView *)makeViewforStackView:(Exercise *)exercise{
    UIView *newView = [UIView new];
    [newView setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
    [newView.heightAnchor constraintEqualToConstant:self.stackView.frame.size.height/3].active = true;
    [newView.widthAnchor constraintEqualToConstant:20].active = true;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 50, 30)];
    if(exercise != nil){
        UILabel *reps = [[UILabel alloc] initWithFrame:CGRectMake(190, 25, 50, 30)];
        UILabel *sets = [[UILabel alloc] initWithFrame:CGRectMake(250, 25, 50, 30)];
        label.text = exercise.exerciseName;
        sets.text = [NSString stringWithFormat:@"%@ sets", exercise.numberSets];
        reps.text = [NSString stringWithFormat:@"%@ sets", exercise.numberReps];
        [reps sizeToFit];
        [sets sizeToFit];
        [newView addSubview:reps];
        [newView addSubview:sets];
    }
    else{
        label.text = @"Please choose an exercise!";
    }
    [label setTextColor:[UIColor whiteColor]];
    [label sizeToFit];
    label.numberOfLines = 0;
    newView.layer.cornerRadius = 5;
    [newView addSubview:label];
    return newView;
}

- (UIColor *)hasImproved:(Exercise *)exercise lessRecent:(Exercise *)ex2{
    return [exercise.lastWeight intValue] > [ex2.lastWeight intValue] || [exercise.numberReps intValue] > [ex2.numberSets intValue] || [exercise.numberSets intValue] > [ex2.numberSets intValue] ? [UIColor greenColor] : [UIColor redColor];
}

- (IBAction)changeGraphInfo:(UIGestureRecognizer *)sender {
    if(sender.state != UIGestureRecognizerStateEnded){
        UIView *view1 = [self makeViewforStackView:self.exercise1[1]];
        UIView *view2 = [self makeViewforStackView:self.exercise2[1]];
        UIView *view3 = [self makeViewforStackView:self.exercise3[1]];
        [view1 setBackgroundColor:[self hasImproved:self.exercise1[0] lessRecent:self.exercise1[1]]];
        [view2 setBackgroundColor:[self hasImproved:self.exercise2[0] lessRecent:self.exercise2[1]]];
        [view3 setBackgroundColor:[self hasImproved:self.exercise3[0] lessRecent:self.exercise3[1]]];
        NSArray *allViews = [[NSArray alloc]initWithObjects:view1, view2, view3, nil];
        for(int i = 0 ; i < 3; i++){
            [self.stackView.arrangedSubviews[i] removeFromSuperview];
            [self.stackView insertArrangedSubview:allViews[i] atIndex:i];
        }
    }
    else {
        for(int j = 0 ; j < 3; j++){
            [self setUpStackView:j];
        }
    }
}

- (void)scheduleLackOfExerciseNotification{
    //Timer that actively checks last workout asynchronously
    GymUser *currentUser = [GymUser currentUser];
    if([[NSDate date] timeIntervalSinceDate:currentUser.lastWorkout] > 1){
        [self scheduleNotification:@"No Workout Completed In A While" contentBody:@"We haven't seen you in a while! Come back and complete a workout to get back on track!" identifier:@"LackOfWorkoutNotification"];
    }
}

- (void)scheduleEmptyWorkoutNotification{
        PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
        [query whereKey:@"completed" equalTo:[NSNumber numberWithBool:NO]];
        [query whereKey:@"user" equalTo:[GymUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if(error != nil){
                NSLog(@"%@",error.localizedDescription);
            }
            //Filter by workouts that are more than a day old; need to figure out how to have it continuously checking
            NSArray *incompleteForMoreThanADay = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Workout *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [[NSDate date] timeIntervalSinceDate:evaluatedObject.createdAt] > 1;
            }
                                                                                      ]
            ];
            if(incompleteForMoreThanADay.count != 0){
                [self scheduleNotification:@"Unfinished Workouts!" contentBody:[NSString stringWithFormat:@"You have %lu unfinished workout(s). Come back and complete them!", (long)incompleteForMoreThanADay.count] identifier:@"EmptyWorkoutNotification"];
            }
        }];
}

-(void)getMostRecentExercise:(NSString *)exerciseName completionBlock:(void(^)(NSArray *exercises))completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query whereKey:@"user" equalTo:[GymUser currentUser]];
    [query whereKey:@"exerciseName" equalTo:exerciseName];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSArray *firstAndSecond = objects != nil ? [objects subarrayWithRange:NSMakeRange(0, 2)] : [[NSArray alloc] initWithObjects:@(-1),@(-1), nil];
        completion(firstAndSecond);
    }];
}

- (void)scheduleNotification: title contentBody: contentBody identifier:identifier{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = title;
    content.body = contentBody;
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    [self.center addNotificationRequest:request withCompletionHandler:^(NSError *error){
    }];
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    myDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if(tabBarController.selectedIndex == 1){
        ProfileViewController* next = tabBarController.viewControllers[1];
        next.user = [GymUser currentUser];
    }
}

- (NSInteger)numberOfComponentsInDropdownMenu:(nonnull MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld", (long)component];
}

- (NSInteger)dropdownMenu:(nonnull MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return self.exercises.count;
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Exercise *exercise = self.exercises[row];
    return exercise.exerciseName;
}

@end
