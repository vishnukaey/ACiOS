//
//  LCUserTableViewCell.m
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUserTableViewCell.h"

@implementation LCUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(LCUserDetail *)user
{
  _user = user;
  self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
  self.userImageView.clipsToBounds = YES;
  [_userImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  _userNameLabel.text = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];
  _userLocationLabel.text = [LCUtilityManager performNullCheckAndSetValue:user.location];
  if([user.userID isEqualToString:[LCDataManager sharedDataManager].userID])
  {
    _userAddButton.hidden = YES;
  }
  else
  {
    _userAddButton.hidden = NO;
    [self updateAddButtonImage];
  }
}


-(IBAction)addButtonTapped:(id)sender
{
  FriendStatus status = (FriendStatus)[_user.isFriend integerValue];
  
  switch (status) {
//    case kIsFriend:
      
//      [self removeUserFriend:_user andFriendButton:_userAddButton];
//      break;
//      
//    case kRequestWaiting:
//      [self cancelFriendRequest:_user andFriendButton:_userAddButton];
//      break;
      
    case kNonFriend:
      [self addFriend:_user andFriendButton:_userAddButton];
      break;
      
    default:
      break;
  }
}

-(void) updateAddButtonImage
{
  [_userAddButton setfriendStatusButtonImageForStatus:(FriendStatus)[_user.isFriend integerValue]];
}

- (void)addFriend:(LCUserDetail*)friendObj andFriendButton:(LCfriendButton*)btn
{
  LCfriendButton * friendBtn = btn;
  
  [friendBtn setfriendStatusButtonImageForStatus:kRequestWaiting];
  
  [LCAPIManager sendFriendRequest:friendObj.userID withSuccess:^(NSArray *response) {
    NSLog(@"%@",response);
    friendObj.isFriend = kFriendStatusWaiting;
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
    [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
  }];
  
}
//


@end
