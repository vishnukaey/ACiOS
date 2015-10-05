//
//  LCfriendButton.h
//  LegacyConnect
//
//  Created by qbuser on 05/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kMyProfile,
  kIsFriend,
  kNonFriend,
  kRequestWaiting
}FriendStatus;

static NSString * kFriendStatusMyProfile = @"0";
static NSString * kFriendStatusMyFriend = @"1";
static NSString * kFriendStatusNonFriend = @"2";
static NSString * kFriendStatusWaiting = @"3";


@interface LCfriendButton : UIButton

- (void)setfriendStatusButtonImageForStatus:(FriendStatus)status;

@end
