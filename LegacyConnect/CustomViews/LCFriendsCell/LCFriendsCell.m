//
//  LCFriendsCell.m
//  LegacyConnect
//
//  Created by qbuser on 21/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFriendsCell.h"

@implementation LCFriendsCell

- (void)awakeFromNib {
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
}

@end
