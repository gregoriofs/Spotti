//
//  ProfileViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *joinedAt;
@property (weak, nonatomic) IBOutlet UILabel *gymLocation;
@property (weak, nonatomic) IBOutlet UILabel *friends;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

@end

@implementation ProfileViewController

- (IBAction)didTapProfilePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GymUser *currentUser = [GymUser currentUser];
    self.name.text   = [NSString stringWithFormat:@"%@ %@",currentUser.firstName, currentUser.lasttName];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/d/y, hh:mm aa";
    self.joinedAt.text = [formatter stringFromDate:currentUser.createdAt];
    self.gymLocation.text = @"The gym";
    self.friends.text = [NSString stringWithFormat:@"%lu",(unsigned long)currentUser.friends.count];
    [self.backgroundImage setImageWithURL:[NSURL URLWithString:@"https://media.istockphoto.com/photos/empty-gym-picture-id1132006407?k=20&m=1132006407&s=612x612&w=0&h=Z7nJu8jntywb9jOhvjlCS7lijbU4_hwHcxoVkxv77sg="]];
    [self settheProfilePic:currentUser];
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

@end
