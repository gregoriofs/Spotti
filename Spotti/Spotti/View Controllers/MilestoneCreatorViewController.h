//
//  MilestoneCreatorViewController.h
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 8/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol savedMilestone <NSObject>
-(void)dismissMilestoneCreatorVC;
@end
@interface MilestoneCreatorViewController : UIViewController
@property (weak, nonatomic) id<savedMilestone> delegate;
@end

NS_ASSUME_NONNULL_END
