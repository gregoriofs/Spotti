//
//  ProfileViewController.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PFImageView.h>
#import "BasicInformationViewController.h"
#import "GymUser.h"
#import "UIKit+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) GymUser *user;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
@property (strong, nonatomic) NSArray *arrayOfWorkouts;
@end

NS_ASSUME_NONNULL_END
