//
//  LCFriendsCell.m
//  LegacyConnect
//
//  Created by qbuser on 21/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFriendsCell.h"
static CGFloat kAvatarImageCornerRadius = 31.5f;

@implementation LCFriendsCell

- (void)awakeFromNib {
  self.friendsImageView.layer.cornerRadius = kAvatarImageCornerRadius;
  self.friendsImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setFriendObj:(LCFriend *)friendObj
{
  _friendObj = friendObj;
  [self.friendsNameLabel setText:[NSString stringWithFormat:@"%@ %@",friendObj.firstName,friendObj.lastName]];
  [self.friendsLocationLabel setText:@"Test Location"];
  [self.friendsImageView sd_setImageWithURL:[NSURL URLWithString:friendObj.avatarURL] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  UIImage * addRemoveFriendBtnImg =[LCFriend isAlreadyFriend:friendObj] ? [UIImage imageNamed:@"AddFriendButton"] : [UIImage imageNamed:@"RemoveFriendButton"];
  [self.addRemoveFriendBtn setImage:addRemoveFriendBtnImg forState:UIControlStateNormal];
}

@end
