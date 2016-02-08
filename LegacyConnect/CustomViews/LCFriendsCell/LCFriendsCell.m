//
//  LCFriendsCell.m
//  LegacyConnect
//
//  Created by qbuser on 21/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//


#import "LCFriendsCell.h"
static CGFloat kAvatarImgCnrRadius = 31.5f;

@implementation LCFriendsCell

- (void)awakeFromNib {
  self.friendsImageView.layer.cornerRadius = kAvatarImgCnrRadius;
  self.friendsImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setFriendObj:(LCFriend *)friendObj
{
  _friendObj = friendObj;
  [self.friendsNameLabel setText:[NSString stringWithFormat:@"%@ %@",friendObj.firstName,friendObj.lastName]];
  [self.friendsLocationLabel setText:friendObj.addressCity];
  [self.friendsImageView sd_setImageWithURL:[NSURL URLWithString:friendObj.avatarURL] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  [self.changeFriendStatusBtn setfriendStatusButtonImageForStatus:(FriendStatus)[self.friendObj.isFriend integerValue]];
}

@end
