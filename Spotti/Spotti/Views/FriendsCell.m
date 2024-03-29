//
//  FriendsCell.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/15/22.
//

#import "FriendsCell.h"

@implementation FriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUser:(GymUser *)user{
    _user = user;
    _username.text = user.username;
    _gym.text = user.gym;
    _profileImage.file = user.profilePic;
    [_profileImage loadInBackground];
    [_gym sizeToFit];
}

@end
