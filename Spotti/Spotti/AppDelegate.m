//
//  AppDelegate.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/6/22.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <UserNotifications/UserNotifications.h>
#import "HomeViewController.h"
#import "GymUser.h"
#import "Workout.h"
#import "SceneDelegate.h"
#import "ObjectivesViewController.h"
#import "MapKit/MapKit.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            configuration.applicationId = @"xVnlYRBVdEVtuTFlNW9ZMwPE0ioOaNILpBc8tbJD";
            configuration.clientKey = @"Ip53v5apI7ixswIKYkiUAwVrMc4K7OvQkjzFOP5D";
            configuration.server = @"https://parseapi.back4app.com/";
        }]];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:options
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted && [GymUser currentUser]){
            UNNotificationAction *workoutAction = [UNNotificationAction actionWithIdentifier:@"takeToWorkout" title:@"Go Workout!" options:UNNotificationActionOptionForeground];
            UNNotificationAction *missingWorkout = [UNNotificationAction actionWithIdentifier:@"finishWorkout" title:@"Finish last workout!" options:UNNotificationActionOptionForeground];
            UNNotificationCategory *lackOfWorkoutCategory = [UNNotificationCategory categoryWithIdentifier:@"LackOfWorkoutCategory" actions:[NSArray arrayWithObjects:workoutAction, nil] intentIdentifiers:[NSArray new] options:UNNotificationCategoryOptionHiddenPreviewsShowTitle];
            UNNotificationCategory *unfinishedWorkout = [UNNotificationCategory categoryWithIdentifier:@"EmptyWorkoutCategory" actions:[NSArray arrayWithObjects:missingWorkout, nil] intentIdentifiers:[NSArray new] options:UNNotificationCategoryOptionHiddenPreviewsShowTitle];
            [center setNotificationCategories:[NSSet setWithObjects:lackOfWorkoutCategory, unfinishedWorkout, nil]];
            [self scheduleLackOfExerciseNotification];
            [self scheduleEmptyWorkoutNotification];
        }
    }];
    [self checkIfAtGym];
    return YES;
}

- (void)scheduleLackOfExerciseNotification{
    //Timer that actively checks last workout asynchronously
    GymUser *currentUser = [GymUser currentUser];
    if([[NSDate date] timeIntervalSinceDate:currentUser.lastWorkout] > 1) {
        [self scheduleNotification:@"No Workout Completed In A While" contentBody:@"We haven't seen you in a while! Come back and complete a workout to get back on track!" identifier:@"LackOfWorkoutNotification" categoryIdentifier:@"LackOfWorkoutCategory"];
    }
}

- (void) checkIfAtGym{
    GymUser* curr = [GymUser currentUser];
    if(curr.gym && curr.lastLocation){
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(curr.lastLocation.latitude, curr.lastLocation.longitude), MKCoordinateSpanMake(.05, .05));
        MKLocalSearchRequest *request = [MKLocalSearchRequest new];
        request.naturalLanguageQuery = curr.gym;
        request.region = region;
        MKLocalSearch *searchGyms = [[MKLocalSearch alloc] initWithRequest:request];
        [searchGyms startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
                    if(!error){
                        for(MKMapItem* item in response.mapItems){
                            if(item.isCurrentLocation){
                                [curr setAtGym:YES];
                                [curr saveInBackground];
                            }
                        }
                    }
        }];
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
            }]];
            if(incompleteForMoreThanADay.count != 0){
                [self scheduleNotification:@"Unfinished Workouts!" contentBody:[NSString stringWithFormat:@"You have %lu unfinished workout(s). Come back and complete them!", (long)incompleteForMoreThanADay.count] identifier:@"EmptyWorkoutNotification" categoryIdentifier:@"EmptyWorkoutCategory"];
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
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError *error){
        }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
        if([response.actionIdentifier isEqualToString:@"takeToWorkout"]){
            NSLog(@"here");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openObjectiveWorkout" object:nil];
            completionHandler();
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openLastWorkout" object:nil];
            completionHandler();
        }
    }


#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
