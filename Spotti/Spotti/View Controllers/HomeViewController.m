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
#import "ObjectivesViewController.h"
#import "WorkoutOverviewViewController.h"
#import "MapKit/MapKit.h"


@interface HomeViewController () <UNUserNotificationCenterDelegate, UITabBarControllerDelegate>

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
@property (weak, nonatomic) IBOutlet UIStackView *friendStackView;
@property (strong, nonatomic) NSArray *exercises;
@property (strong, nonatomic) NSArray *friendsAtGym;
@end

@implementation HomeViewController

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionSound);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.center = [UNUserNotificationCenter currentNotificationCenter];
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
                                    [self setUpStackView:i stackView:NO];
                                });
                            }];
                        }];
                    }
                    else if(i == 1){
                        act = [UIAction actionWithTitle:exercise.exerciseName image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [self getMostRecentExercise:exercise.exerciseName completionBlock:^(NSArray *exercises) {
                                                            self.exercise2 = exercises;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self setUpStackView:i stackView:NO];
                                });
                            }];
                        }];
                    }
                    else{
                        act = [UIAction actionWithTitle:exercise.exerciseName image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [self getMostRecentExercise:exercise.exerciseName completionBlock:^(NSArray *exercises) {
                                                            self.exercise3 = exercises;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self setUpStackView:i stackView:NO];
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
    [self setUpStackView:1 stackView:NO];
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.center.delegate = self;
    self.createSessionButton.layer.cornerRadius = 5;
    self.addFriendsButton.layer.cornerRadius = 5;
    self.exerciseListButton.layer.cornerRadius = 5;
    [self addShadow:self.createSessionButton];
    [self addShadow:self.exerciseListButton];
    [self addShadow:self.addFriendsButton];
    [self findFriendsAtGym:^(NSArray *friendsAtGym) {
        self.friendsAtGym = friendsAtGym;
        [self setUpStackView:nil stackView:YES];
    }];
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@!", [GymUser currentUser].username];
//    [GymUser currentUser] curre
}

- (void)addShadow: (UIButton *)button {
    button.layer.shadowColor = [[UIColor grayColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(0, 5.0);
    button.layer.shadowRadius = 5;
    button.layer.shadowOpacity = 1.0;
}

- (IBAction)clickButton:(id)sender {
    [sender setHighlighted:YES];
}

- (void)findFriendsAtGym:(void(^)(NSArray* friendsAtGym))completionBlock{
    NSArray *friends = [GymUser currentUser].friends;
    NSMutableArray *atGym = [NSMutableArray new];
    for(GymUser* friend in friends){
        [friend fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            GymUser *user = (GymUser *)object;
            if(user.atGym){
                [atGym addObject:user];
            }
        }];
    }
    completionBlock([atGym copy]);
}

- (void)setUpStackView:(NSInteger)indexToInsert stackView:(BOOL)isFriends{
    if(!isFriends){
        if(self.stackView.arrangedSubviews.count == 0){
            [self.stackView addArrangedSubview:[self makeViewforStackView:nil friendView:nil]];
            [self.stackView addArrangedSubview:[self makeViewforStackView:nil friendView:nil]];
            [self.stackView addArrangedSubview:[self makeViewforStackView:nil friendView:nil]];
        }
        else {
            UIView *newView = [self makeViewforStackView:self.exercise1[0] friendView:nil];;
            if(indexToInsert == 1){
                newView = [self makeViewforStackView:self.exercise2[0] friendView:nil];
            }
            else if (indexToInsert == 2){
                newView = [self makeViewforStackView:self.exercise3[0] friendView:nil];
            }
            [self.stackView.arrangedSubviews[indexToInsert] removeFromSuperview];
            [self.stackView insertArrangedSubview:newView atIndex:indexToInsert];
        }
    }
    else {
        NSArray *friends = [GymUser currentUser].friends;
        NSInteger shownFriends = friends.count >= 3 ? 3 : friends.count;
        for(int i = 0; i < shownFriends; i++){
            UIView *view = [self makeViewforStackView:nil friendView:friends[i]];
            [self.friendStackView addArrangedSubview:view];
        }
    }
}

- (UIView *)makeViewforStackView:(Exercise *)exercise friendView:(GymUser *)friend{
    UIView *newView = [UIView new];
    if(!friend){
        [newView setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [newView.heightAnchor constraintEqualToConstant:self.stackView.frame.size.height/3].active = true;
        [newView.widthAnchor constraintEqualToConstant:20].active = true;
        newView.layer.borderWidth = 2;
        newView.layer.borderColor = [UIColor blackColor].CGColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 50, 30)];
        if(![exercise isEqual:@(-1)] && exercise != nil){
            UILabel *reps = [[UILabel alloc] initWithFrame:CGRectMake(190, 25, 50, 30)];
            UILabel *sets = [[UILabel alloc] initWithFrame:CGRectMake(250, 25, 50, 30)];
            label.text = exercise.exerciseName;
            sets.text = [NSString stringWithFormat:@"%@ sets", exercise.numberSets];
            reps.text = [NSString stringWithFormat:@"%@ reps", exercise.numberReps];
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
    }
    else {
        [newView setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [newView.heightAnchor constraintEqualToConstant:self.friendStackView.frame.size.height/3].active = true;
        [newView.widthAnchor constraintEqualToConstant:20].active = true;
        newView.layer.cornerRadius = 5;
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(70, newView.frame.size.height/2, 40, 30)];
        UILabel *gymName = [[UILabel alloc] initWithFrame:CGRectMake(140, newView.frame.size.height/2, 40, 30)];
        PFImageView *profilePic = [[PFImageView alloc] initWithFrame:CGRectMake(5, newView.frame.size.height/2 + 5, 50, 30)];
        newView.layer.borderWidth = 2;  
        newView.layer.borderColor = [UIColor blackColor].CGColor;
        [friend fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            profilePic.file = ((GymUser *)object).profilePic;
            [profilePic loadInBackground];
            name.text = friend.username;
            gymName.text = friend.gym ? friend.gym : @"the gym";
        }];
        [gymName setTextColor:[UIColor whiteColor]];
        [gymName sizeToFit];
        [name setTextColor:[UIColor whiteColor]];
        [newView addSubview:gymName];
        [newView addSubview:name];
        [newView addSubview:profilePic];
    }
    return newView;
}

- (UIColor *)hasImproved:(Exercise *)exercise lessRecent:(Exercise *)ex2{
    return ![exercise isEqual:@(-1)] && ![ex2 isEqual:@(-1)] && ([exercise.lastWeight intValue] > [ex2.lastWeight intValue] || [exercise.numberReps intValue] > [ex2.numberSets intValue] || [exercise.numberSets intValue] > [ex2.numberSets intValue] )? [UIColor greenColor] : [UIColor redColor];
}

- (IBAction)changeGraphInfo:(UIGestureRecognizer *)sender {
    if(sender.state != UIGestureRecognizerStateEnded){
        UIView *view1 = [self makeViewforStackView:self.exercise1[1] friendView:nil];
        UIView *view2 = [self makeViewforStackView:self.exercise2[1] friendView:nil];
        UIView *view3 = [self makeViewforStackView:self.exercise3[1] friendView:nil];
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
            [self setUpStackView:j stackView:NO];
        }
    }
}

- (void)getMostRecentExercise:(NSString *)exerciseName completionBlock:(void(^)(NSArray *exercises))completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query whereKey:@"user" equalTo:[GymUser currentUser]];
    [query whereKey:@"exerciseName" equalTo:exerciseName];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSArray *firstAndSecond = objects;
        
        if(objects.count == 1){
            completion([NSArray arrayWithObjects:objects[0],@(-1),nil]);
        }
        else if (objects.count == 0){
            completion([NSArray arrayWithObjects:@(-1),@(-1),nil]);
        }
        else {
            completion([firstAndSecond subarrayWithRange:NSMakeRange(0, 2)]);
        }
        
    }];
}

- (void)scheduleNotification:(NSString *)title contentBody:(NSString *)contentBody identifier:(NSString *)identifier categoryIdentifier:(NSString *)category{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = title;
    content.body = contentBody;
    content.sound = [UNNotificationSound defaultSound];
    content.categoryIdentifier = category;
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

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
        if([response.actionIdentifier isEqualToString:@"takeToWorkout"]){
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ObjectivesViewController *start = [storyboard instantiateViewControllerWithIdentifier:@"focusAreaVC"]; 
            myDelegate.window.rootViewController = start;
        }
        else{
            PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
            GymUser *user = [GymUser currentUser];
            [query whereKey:@"user" equalTo:user];
            [query whereKey:@"completed" equalTo:[NSNumber numberWithBool:NO]];
            [query orderByDescending:@"createdAt"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error != nil){
                    NSLog(@"%@", error.localizedDescription);
                    }
                else {
                    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                    Workout *current = objects[0];
                    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UINavigationController *lastWorkout = [main instantiateViewControllerWithIdentifier:@"workoutOverview"];
                    ((WorkoutOverviewViewController *)lastWorkout.topViewController).workout = current;
                    ((WorkoutOverviewViewController *)lastWorkout.topViewController).fromList = NO;
                    myDelegate.window.rootViewController = lastWorkout;
                }
            }];
        }
    }

@end
