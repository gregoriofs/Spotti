//
//  FriendProfileViewController.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendProfileViewController : ProfileViewController
@property (strong, nonatomic) GymUser *user;
@end

NS_ASSUME_NONNULL_END
