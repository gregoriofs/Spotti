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

@interface HomeViewController () <UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UNUserNotificationCenter *center;
@property (weak, nonatomic) IBOutlet UIButton *createSessionButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendsButton;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation HomeViewController

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    completionHandler(UNNotificationPresentationOptionList);
    completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionSound);
}
//TODO: Why are notifications not showing??
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
    self.center.delegate = self;
    [self scheduleLackOfExerciseNotification];
    self.createSessionButton.layer.cornerRadius = 5;
    self.addFriendsButton.layer.cornerRadius = 5;
    self.createSessionButton.layer.cornerRadius = 5;
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@!", [GymUser currentUser].username];
}

-(void)scheduleLackOfExerciseNotification{
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

@end
