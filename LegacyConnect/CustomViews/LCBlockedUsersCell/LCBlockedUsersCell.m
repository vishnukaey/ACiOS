//
//  LCBlockedUsersCell.m
//  LegacyConnect
//
//  Created by qbuser on 30/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCBlockedUsersCell.h"

static CGFloat kAvatarImageCornerRadius = 31.5f;
@implementation LCBlockedUsersCell

- (void)awakeFromNib {
  self.friendsImageView.layer.cornerRadius = kAvatarImageCornerRadius;
  self.friendsImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)setUserDetails:(LCUserDetail *)userDetails
{
  _userDetails = userDetails;
  [self.friendsNameLabel setText:[NSString stringWithFormat:@"%@ %@",self.userDetails.firstName,self.userDetails.lastName]];
  [self.friendsLocationLabel setText:self.userDetails.location];
  [self.friendsImageView sd_setImageWithURL:[NSURL URLWithString:self.userDetails.avatarURL] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  self.unblockButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.unblockButton.layer.borderWidth = 1;
  self.unblockButton.layer.cornerRadius = 4;
}

@end
