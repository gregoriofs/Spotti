//
//  FriendProfileViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/18/22.
//

#import "FriendProfileViewController.h"
#import "WorkoutOverviewViewController.h"

@interface FriendProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end

@implementation FriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GymUser currentUser] fetch];
    if([self checkIfFriend:self.user.objectId]){
        [self.addFriendButton setTitle:@"Already Friends" forState:UIControlStateNormal];
    }
}

- (IBAction)didTapAddFriend:(id)sender {
    GymUser *currentUser = [GymUser currentUser];
    [currentUser fetchIfNeeded];
    if(![self checkIfFriend:self.user.objectId]){
        currentUser.friends  = [currentUser.friends arrayByAddingObject:self.user];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error){
                NSLog(@"%@", error.localizedDescription);
            }
            [self.addFriendButton setTitle:@"Already Friends" forState:UIControlStateNormal];
        }];
    }
}
- (BOOL)checkIfFriend:(NSString *)addedUserId{
    for(GymUser *friend in [GymUser currentUser].friends){
        if([friend.objectId isEqualToString:addedUserId]){
            return YES;
        }
    }
    return NO;
}
//showingFriendsWorkoutSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"showingFriendsWorkoutSegue"]){
        UINavigationController *destination = [segue destinationViewController];
        WorkoutOverviewViewController *newVC = (WorkoutOverviewViewController *)destination.topViewController;
        newVC.workout = self.arrayOfWorkouts[[self.tableView indexPathForCell:sender].row];
    }
    
}

@end
