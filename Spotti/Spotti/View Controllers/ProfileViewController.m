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
#import "Exercise.h"
#import "ListofWorkoutsViewController.h"
@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, dismissVC>

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
    GymUser *currentUser = [[self.parentViewController restorationIdentifier] isEqualToString:@"homeVC"] ? [GymUser currentUser] : self.user;
    self.name.text   = [NSString stringWithFormat:@"%@ %@",currentUser.firstName, currentUser.lasttName];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/d/y, hh:mm aa";
    self.joinedAt.text = [formatter stringFromDate:currentUser.createdAt];
    self.gymLocation.text = @"The gym";
    self.friends.text = [NSString stringWithFormat:@"%lu friends",(unsigned long)currentUser.friends.count];
    [self.backgroundImage setImageWithURL:[NSURL URLWithString:@"https://media.istockphoto.com/photos/empty-gym-picture-id1132006407?k=20&m=1132006407&s=612x612&w=0&h=Z7nJu8jntywb9jOhvjlCS7lijbU4_hwHcxoVkxv77sg="]];
    [self settheProfilePic:currentUser];
    self.gymLocation.text = currentUser.gym;
    self.profilePic.layer.cornerRadius = 256/2;
    self.currentStreak.text = [NSString stringWithFormat:@"%d days in a row!", [currentUser.streak intValue]];
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
    [self.favoriteExercise sizeToFit];
    [self.gymLocation sizeToFit];
    self.addProfilePictureButton.layer.cornerRadius = 5;
    [self findFavoriteExercise:^(NSString *mostPopular, NSString *mostReps) {
            self.favoriteExercise.text = [NSString stringWithFormat:@"Favorite Exercise: %@", mostPopular];
        self.personalRecord.text = mostReps;
    }];
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

- (void)findFavoriteExercise:(void(^)(NSString *mostPopular, NSString *highestRecord))completionBlock{
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query whereKey:@"user" equalTo:[GymUser currentUser]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            NSMutableDictionary *frequency = [NSMutableDictionary new];
            NSInteger maxWeight = 0;
            NSString *mostWeightExercise = nil;
            for(Exercise *exercise in objects){
                if([exercise.lastWeight intValue] >= maxWeight){
                    maxWeight = [exercise.lastWeight intValue];
                    mostWeightExercise = [NSString stringWithFormat:@"%@ for %d reps with %d lbs", exercise.exerciseName, [exercise.numberReps intValue], [exercise.lastWeight intValue]];
                }
                NSString *key = exercise.exerciseName;
                if(![[frequency allKeys] containsObject:key]){
                    [frequency setObject:[NSNumber numberWithInt:1] forKey:key];
                }
                else{
                    frequency[key] = [NSNumber numberWithInt:[frequency[key] intValue] + 1];
                }
            }
        NSNumber *maxValue = [NSNumber numberWithInt:0];
        NSString *maxkey = nil;
        for(NSString *key in [frequency allKeys]) {
            if([frequency[key] intValue] > [maxValue intValue]){
                maxkey = key;
                maxValue = frequency[key];
            }
        }
        completionBlock(maxkey, mostWeightExercise);
    }];
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
    GymUser *user = [[self.parentViewController restorationIdentifier] isEqualToString:@"homeVC"] ? [GymUser currentUser] : self.user;
    [query whereKey:@"user" equalTo:user];
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
    ListofWorkoutsViewController *newVC = [segue destinationViewController];
    newVC.user = [GymUser currentUser];
}

- (void)dismissWorkoutVC {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
