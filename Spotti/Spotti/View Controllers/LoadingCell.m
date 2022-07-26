//
//  LoadingCell.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/25/22.
//

#import "LoadingCell.h"

@implementation LoadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.activityIndicator.hidesWhenStopped = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
