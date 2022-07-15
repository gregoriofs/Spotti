//
//  AddingFriendsViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import "AddingFriendsViewController.h"
#import <Parse/Parse.h>


@interface AddingFriendsViewController () <UISearchDisplayDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSArray *filteredList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *allUsers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AddingFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    
}

-(void)queryAllUsers{
    PFQuery *query = [PFQuery queryWithClassName:@"GymUser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allUsers = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
