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
#import "PriorityQueue.h"
#import "PriorityQueueNode.h"

@interface AddingFriendsViewController () <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray *filteredList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *allUsers;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CLLocationCoordinate2D lastLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation AddingFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator = [UIActivityIndicatorView new];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.currentPage = 0;
    self.locationManager = [CLLocationManager new];
    self.allUsers = [NSArray new];
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self queryAllUsers:self.currentPage];
    if([_locationManager locationServicesEnabled]){
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 50;
        [_locationManager requestWhenInUseAuthorization];
    };
}

- (IBAction)segControl:(id)sender {
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    if(index == 0){
        self.filteredList = nil;
        [self.tableView reloadData];
    }
    else if(index == 1){
        [self mapSearch];
    }
}

-(void)queryAllUsers:(NSInteger)page{
    PFQuery *query = [GymUser query];
    NSInteger pageLimit = 8;
    [query setLimit:10];
    [query setSkip:pageLimit * page];
    [query whereKey:@"objectId" notEqualTo:[GymUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            NSMutableArray *temp = [self.allUsers mutableCopy];
            for(GymUser *user in users){
                if(![temp containsObject:user]){
                    [temp addObject:user];
                }
            }
            self.allUsers = [temp copy];
            self.currentPage += 1;
            self.isLoading = NO;
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isLoading){
        NSInteger scrollViewContentHeight = self.tableView.contentSize.height;
        NSInteger scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging){
            self.isLoading = YES;
            [self.activityIndicator startAnimating];
            [self queryAllUsers:self.currentPage];
            if([self.segmentedControl selectedSegmentIndex] == 1){
                [self mapSearch];
            }
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell" forIndexPath:indexPath];
    GymUser *cellUser = self.filteredList[indexPath.row];
    [cell setUser:cellUser];
    [cell.gym sizeToFit];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredList.count;
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
    if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse){
        [manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations firstObject];
    _lastLocation = location.coordinate;
    PFGeoPoint *currLocation = [PFGeoPoint new];
    currLocation.latitude = location.coordinate.latitude;
    currLocation.longitude = location.coordinate.longitude;
    [[GymUser currentUser] setObject:currLocation forKey:@"lastLocation"];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0){
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject[@"username"] containsString:searchText];
        }];
        self.filteredList = [self.allUsers filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredList = [NSArray new];
    }
    [self.tableView reloadData];
}

- (NSInteger)friendsInCommon:(GymUser *)user {
    NSArray *friends = user.friends;
    NSInteger common = 0;
    for(GymUser *friend in friends){
        if([[[GymUser currentUser].friends valueForKey:@"objectId"] containsObject:friend.objectId]){
            common += 1;
        }
    }
    return common;
}

- (void)mapSearch{
    MKCoordinateRegion region = MKCoordinateRegionMake(self.lastLocation, MKCoordinateSpanMake(.05, .05));
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Gyms";
    request.region = region;
    MKLocalSearch *searchGyms = [[MKLocalSearch alloc] initWithRequest:request];
    PriorityQueue *queue = [PriorityQueue new];
    queue.comparator = ^NSComparisonResult(PriorityQueueNode* obj1, PriorityQueueNode* obj2) {
        NSComparisonResult result = NSOrderedSame;
        if ([obj1.priority intValue] < [obj2.priority intValue]) {
            result = NSOrderedDescending;
        } else if ([obj1.priority intValue] > [obj2.priority intValue]) {
            result = NSOrderedAscending;
        }
        return result;
    };
    [searchGyms startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"%@",error.localizedDescription);
            }
            NSMutableDictionary *prios = [[NSMutableDictionary alloc] init];
            for(MKMapItem *item in response.mapItems){
                float lat = item.placemark.coordinate.latitude;
                float longit = item.placemark.coordinate.longitude;
                for(GymUser *user in self.allUsers){
                    CLLocationDistance distance = [[[CLLocation alloc]initWithLatitude:lat longitude:longit] distanceFromLocation:[[CLLocation alloc]initWithLatitude:user.lastLocation.latitude longitude:user.lastLocation.longitude]];
                    NSString *key = user.username;
                    if(![[prios allKeys] containsObject:key]){
                        NSInteger friendsInCommon = [self friendsInCommon:user];
                        if([item.name isEqualToString:[GymUser currentUser].gym] && [user.gym isEqualToString:[GymUser currentUser].gym]){
                            [prios setObject:[NSNumber numberWithInt:friendsInCommon * 1.5] forKey:key];
                        }
                        else {
                            [prios setObject:[NSNumber numberWithInt:friendsInCommon] forKey:key];
                        }
                    }
                    if(distance <= 1610){
                        NSInteger prio = [item.name isEqualToString:[GymUser currentUser].gym] && [user.gym isEqualToString:[GymUser currentUser].gym] ? 3 : 1;
                        prios[key] = [NSNumber numberWithInt:[prios[key] intValue] + prio];
                    }
                    if([item.name isEqualToString:[GymUser currentUser].gym] && [user.gym isEqualToString:[GymUser currentUser].gym]){
                        prios[key] = [NSNumber numberWithInt:[prios[key] intValue] + 1];
                    }
                }
            }
            for(NSString *key in [prios allKeys]){
                NSUInteger objIndex = [self.allUsers indexOfObjectPassingTest:^BOOL(GymUser *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return [obj.username isEqualToString:key];
                }];
                PriorityQueueNode *node = [[PriorityQueueNode alloc] initWithPriority:prios[key] user:self.allUsers[objIndex]];
                [queue add:node];
            }
        NSArray *results = [[[queue toArray] valueForKey:@"user"] copy];
        self.filteredList = results;
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"addFriendSegue"]){
        NSIndexPath *currPath = [self.tableView indexPathForCell:sender];
        GymUser *thisUser = self.filteredList[currPath.row];
        FriendProfileViewController *next = [segue destinationViewController];
        next.user = thisUser;
    }
}

@end
