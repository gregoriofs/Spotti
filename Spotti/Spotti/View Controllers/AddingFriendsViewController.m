//
//  AddingFriendsViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import "AddingFriendsViewController.h"
#import <Parse/Parse.h>
#import "FriendsCell.h"
#import "GymUser.h"

@interface AddingFriendsViewController () <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *filteredList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *allUsers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AddingFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 92;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self queryAllUsers];
}

-(void)queryAllUsers{
    //TODO: take care of random username entry
    //Pop up window indicating that user wasn't found
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:[GymUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.allUsers = users;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
    GymUser *cellUser = self.allUsers[indexPath.row];
    cell.profileImage.file = cellUser.profilePic;
    [cell.profileImage loadInBackground];
    cell.username.text = cellUser.username;
    cell.gym.text = cellUser.gym;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allUsers.count;
}

@end
