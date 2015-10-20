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
  _userLocationLabel.text = [NSString stringWithFormat:@"%@ ",user.location];
  [self updateAddButtonImage];
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
  
//  [_userAddButton setfriendStatusButtonImageForStatus:kRequestWaiting];
//  [LCAPIManager sendFriendRequest:_user.userID withSuccess:^(id response) {
//    _user.isFriend = kFriendStatusWaiting;
//    [self updateAddButtonImage];
//  } andFailure:^(NSString *error) {
//    [self updateAddButtonImage];
//  }];
}

-(void) updateAddButtonImage
{
  [_userAddButton setfriendStatusButtonImageForStatus:(FriendStatus)[_user.isFriend integerValue]];
}


//- (void)removeUserFriend:(LCUserDetail*)friendObj andFriendButton:(LCfriendButton*)btn
//{
//  LCfriendButton * friendBtn = btn;
//  //remove friend
//  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//  actionSheet.view.tintColor = [UIColor blackColor];
//  
//  UIAlertAction *removeFriend = [UIAlertAction actionWithTitle:@"Remove Friend" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//    //change button image
//    [friendBtn setfriendStatusButtonImageForStatus:kNonFriend];
//    
//    [LCAPIManager removeFriend:friendObj.userID withSuccess:^(NSArray *response)
//     {
//       friendObj.isFriend = kFriendStatusNonFriend;
//     }
//            andFailure:^(NSString *error)
//     {
//       //Set previous button state
//       [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
//       NSLog(@"%@",error);
//     }];
//  }];
//  [actionSheet addAction:removeFriend];
//  
//  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//  [actionSheet addAction:cancelAction];
//  [self presentViewController:actionSheet animated:YES completion:nil];
//}
//
//- (void)cancelFriendRequest:(LCUserDetail*)friendObj andFriendButton:(LCfriendButton*)btn
//{
//  //cancel friend request
//  LCfriendButton * friendBtn = btn;
//  
//  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//  actionSheet.view.tintColor = [UIColor blackColor];
//  
//  UIAlertAction *cancelFreindRequest = [UIAlertAction actionWithTitle:@"Cancel Friend Request" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//    
//    [friendBtn setfriendStatusButtonImageForStatus:kNonFriend];
//    
//    
//    [LCAPIManager cancelFriendRequest:friendObj.friendId withSuccess:^(NSArray *response) {
//      NSLog(@"%@",response);
//      friendObj.isFriend = kFriendStatusNonFriend;
//      [self.tableView beginUpdates];
//      [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//      [self.friendsList removeObject:friendObj];
//      [self.tableView endUpdates];
//      
//    } andFailure:^(NSString *error) {
//      //Set previous button state
//      [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
//      NSLog(@"%@",error);
//    }];
//  }];
//  [actionSheet addAction:cancelFreindRequest];
//  
//  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//  [actionSheet addAction:cancelAction];
//  [self presentViewController:actionSheet animated:YES completion:nil];
//  
//}
//
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
