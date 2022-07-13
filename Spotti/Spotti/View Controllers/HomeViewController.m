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

@interface HomeViewController ()

@property (strong, nonatomic) UNUserNotificationCenter *center;

@end

@implementation HomeViewController

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
    [self scheduleEmptyWorkoutNotification];
}

-(void)scheduleEmptyWorkoutNotification{
    PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
    [query whereKey:@"completed" equalTo:[NSNumber numberWithBool:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(error != nil){
            NSLog(@"%@",error.localizedDescription);
        }
        //Filter by workouts that are more than a day old; need to figure out how to have it continuously checking
        NSArray *incompleteForMoreThanADay = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Workout *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [[NSDate date] timeIntervalSinceDate:evaluatedObject.createdAt] >= 82400;
        }
                                                                                  ]
        ];
        if(incompleteForMoreThanADay.count != 0){
            UNMutableNotificationContent *content = [UNMutableNotificationContent new];
            content.title = @"Unfinished Workouts!";
            content.body = [NSString stringWithFormat:@"You have %lu incomplete workout(s) for more than a day. Come back quickly and finish them!", (unsigned long)incompleteForMoreThanADay.count];
            content.sound = [UNNotificationSound defaultSound];
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            NSString *identifier = @"EmptyWorkoutNotification";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
            [self.center addNotificationRequest:request withCompletionHandler:^(NSError *error){
                NSLog(@"%@", error.localizedDescription);
            }];
        }
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
