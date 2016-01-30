//
//  LCBlockedUsersCell.m
//  LegacyConnect
//
//  Created by qbuser on 30/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCBlockedUsersCell.h"

@implementation LCBlockedUsersCell

- (void)awakeFromNib {
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
}

@end
