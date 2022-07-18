//
//  FriendsCell.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/15/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PFImageView.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *gym;
@end

NS_ASSUME_NONNULL_END
