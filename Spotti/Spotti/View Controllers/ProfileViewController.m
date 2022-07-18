//
//  ProfileViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import "ProfileViewController.h"
#import "WorkoutCell.h"
#import "Workout.h"
#import "WorkoutOverviewViewController.h"
#import "UserNotifications/UserNotifications.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *joinedAt;
@property (weak, nonatomic) IBOutlet UILabel *gymLocation;
@property (weak, nonatomic) IBOutlet UILabel *friends;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *statView;
@property (weak, nonatomic) IBOutlet UILabel *favoriteExercise;
@property (weak, nonatomic) IBOutlet UILabel *currentStreak;
@property (weak, nonatomic) IBOutlet UILabel *personalRecord;
@property (weak, nonatomic) IBOutlet UITableView *workoutTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *addProfilePictureButton;

@end

@implementation ProfileViewController
//TODO: move workout viewing to its own screen with tableview if scrollview can't be fixed
- (void)viewDidLoad {
    [super viewDidLoad];
    self.workoutTableView.delegate = self;
    self.workoutTableView.dataSource = self;
    GymUser *currentUser = [GymUser currentUser];
    self.name.text   = [NSString stringWithFormat:@"%@ %@",currentUser.firstName, currentUser.lasttName];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/d/y, hh:mm aa";
    self.joinedAt.text = [formatter stringFromDate:currentUser.createdAt];
    self.gymLocation.text = @"The gym";
    self.friends.text = [NSString stringWithFormat:@"%lu",(unsigned long)currentUser.friends.count];
    [self.backgroundImage setImageWithURL:[NSURL URLWithString:@"https://media.istockphoto.com/photos/empty-gym-picture-id1132006407?k=20&m=1132006407&s=612x612&w=0&h=Z7nJu8jntywb9jOhvjlCS7lijbU4_hwHcxoVkxv77sg="]];
    [self settheProfilePic:currentUser];
    self.gymLocation.text = currentUser.gym;
    self.profilePic.layer.cornerRadius = 256/2;
    self.name.layer.cornerRadius = 5;
    self.friends.layer.cornerRadius = 5;
    self.joinedAt.layer.cornerRadius = 5;
    self.gymLocation.layer.cornerRadius = 5;
    self.infoView.layer.cornerRadius = 8;
    self.favoriteExercise.layer.cornerRadius = 5;
    self.currentStreak.layer.cornerRadius = 5;
    self.personalRecord.layer.cornerRadius = 5;
    self.statView.layer.cornerRadius = 8;
    self.workoutTableView.rowHeight = UITableViewAutomaticDimension;
    self.workoutTableView.estimatedRowHeight = 65;
    self.scrollView.delegate = self;
    self.scrollView.bounces = false;
    self.workoutTableView.bounces = false;
    [self.workoutTableView setScrollEnabled:false];
    self.addProfilePictureButton.layer.cornerRadius = 5;
    [self getWorkouts];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (scrollView == self.scrollView){
        if (yOffset >= 300){
            [self.scrollView setScrollEnabled:NO];
            [self.workoutTableView setScrollEnabled:YES];
        }
    }
    if (scrollView == self.workoutTableView){
        if (yOffset <= 0){
            [self.scrollView setScrollEnabled:YES];
            [self.workoutTableView setScrollEnabled:NO];
        }
    }
}

- (IBAction)didTapProfilePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)settheProfilePic:(GymUser *)user {
    self.profilePic.file = user.profilePic;
    [self.profilePic loadInBackground];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    GymUser *user = [GymUser currentUser];
    user[@"profilePic"] = [ProfileViewController getPFFileFromImage:editedImage];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self settheProfilePic:[GymUser currentUser]];
        }
    }];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getWorkouts{
    PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
    [query whereKey:@"user" equalTo:[GymUser currentUser]];
    [query setLimit:5];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"%@", error.localizedDescription);
            }
            else{
                self.arrayOfWorkouts = objects;
                [self.workoutTableView reloadData];
            }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell"];
    Workout *workout = self.arrayOfWorkouts[indexPath.row];
    cell.workout = workout;
    cell.workoutName.text = [NSString stringWithFormat:@"Workout %@",[workout.focusAreas componentsJoinedByString:@","]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfWorkouts.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *destination = [segue destinationViewController];
    WorkoutOverviewViewController *newVC = (WorkoutOverviewViewController *)destination.topViewController;
    newVC.workout = self.arrayOfWorkouts[[self.workoutTableView indexPathForCell:sender].row];
    newVC.fromList = YES;
}

@end
