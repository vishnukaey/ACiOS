//
//  LCfriendButton.m
//  LegacyConnect
//
//  Created by qbuser on 05/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCfriendButton.h"

static NSString * kAddFriend = @"AddFriendButton";
static NSString * kAlreadyFriend = @"profileFriend";
static NSString * kWaitingFriend = @"profileWaiting";

@implementation LCfriendButton

- (void)setfriendStatusButtonImageForStatus:(FriendStatus)status
{
  FriendStatus currentStatus = status;
  NSString * btnImageName = @"";
  switch (currentStatus) {
      
    case kIsFriend:
      btnImageName = kAlreadyFriend;
      break;
      
    case kNonFriend:
      btnImageName = kAddFriend;
      break;
      
    case kRequestWaiting:
      btnImageName = kWaitingFriend;
      break;
      
    default:
      break;
  }
  [self setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
}


@end
