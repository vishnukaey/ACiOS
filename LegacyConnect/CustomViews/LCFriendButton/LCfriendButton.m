//
//  LCfriendButton.m
//  LegacyConnect
//
//  Created by qbuser on 05/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCfriendButton.h"

static NSString * kAddFriend = @"addFriends";
static NSString * kAlreadyFriend = @"friends";
static NSString * kWaitingFriend = @"profileWaiting";

@implementation LCfriendButton

- (void)setfriendStatusButtonImageForStatus:(FriendStatus)status
{
  FriendStatus currentStatus = status;
  NSString *btnImageName = nil;
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
      
    case kBlocked:
      btnImageName = kAddFriend;
      break;
      
    default:
      break;
  }
  if(btnImageName)
  {
    [self setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
  }
}


@end
