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
#import "FriendProfileViewController.h"
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"

@interface AddingFriendsViewController () <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray *filteredList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *allUsers;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CLLocationCoordinate2D lastLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation AddingFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 92;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _locationManager.distanceFilter = 200;
    [_locationManager requestWhenInUseAuthorization];
    [self queryAllUsers];
}

-(void)queryAllUsers{
    //TODO: take care of random username entry
    //Pop up window indicating that user wasn't found
    PFQuery *query = [GymUser query];
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
    GymUser *cellUser = self.filteredList[indexPath.row];
    cell.user = cellUser;
    cell.profileImage.file = cellUser.profilePic;
    [cell.profileImage loadInBackground];
    cell.username.text = cellUser.username;
    cell.gym.text = cellUser.gym;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredList.count;
}

-(void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager status:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations firstObject];
    _lastLocation = location.coordinate;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0){
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject[@"username"] containsString:searchText];
        }];
        self.filteredList = [self.allUsers filteredArrayUsingPredicate:predicate];
    }
    else{
        self.filteredList = [NSArray new];
    }
    [self.tableView reloadData];
}

- (void)mapSearch{
    //Use mkcoordinateregion to limit search around user
    
//    MKLocalSearch *searchGyms = [MKLocalSearch alloc] initWithRequest:[MKLocalSearchRequest ]
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"addFriendSegue"]){
        NSIndexPath *currPath = [self.tableView indexPathForCell:sender];
        GymUser *thisUser = self.filteredList[currPath.row];
        FriendProfileViewController *next = [segue destinationViewController];
        next.user = thisUser;
    }
}

//To search by gyms: Add MapKit, create an MKLocalSearch and get user's current location to get nearby gyms. Once I have a list of gyms, I can filter all users by those that attend one of those gyms.
@end
