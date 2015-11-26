//
//  LCProfileViewBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

/* notifications to be handled
 1: created a post - impacts count for self profile
 2: deleted a post - impacts count for self profile
 2: unfriend - friends count for self profile and add friend button state for friend
 3: Add friend - add friend button state for others profile
 4: cancel friend request
 5: Edit profile - for self profile
 */

#import "LCProfileViewBC.h"


static NSString * const kImageNameProfileSettings = @"profileSettings";
static NSString * const kImageNameProfileAdd = @"profileAdd";
static NSString * const kImageNameProfileFriend = @"profileFriend";
static NSString * const kImageNameProfileWaiting = @"profileWaiting";

@implementation LCProfileViewBC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Add Notification observers
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateUserData:)
                                               name:kUserProfileUpdateNotification object:nil];
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(friendStatusUpdatedNotificationReceived:)
                                               name:kSendFriendRequestNFK
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(friendStatusUpdatedNotificationReceived:)
                                               name:kCancelFriendRequestNFK
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(friendStatusUpdatedNotificationReceived:)
                                               name:kRemoveFriendNFK
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(friendStatusUpdatedNotificationReceived:)
                                               name:kAcceptFriendRequestNFK
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateImpactsCount:)
                                               name:kCreateNewPostNFK
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateImpactsCount:)
                                               name:kDeletePostNFK
                                             object:nil];
}

- (void)dealloc {
  
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCurrentProfileStatus:(FriendStatus)friendStatus
{
  currentProfileStatus = friendStatus;
  NSString *btnImageName = nil;
  switch (currentProfileStatus) {
      
    case kMyProfile:
      btnImageName = kImageNameProfileSettings;
      break;
      
    case kIsFriend:
      btnImageName = kImageNameProfileFriend;
      break;
      
    case kNonFriend:
      btnImageName = kImageNameProfileAdd;
      break;
      
    case kRequestWaiting:
      btnImageName = kImageNameProfileWaiting;
      break;
      
    default:
      break;
  }
  if(btnImageName)
  {
    [friendsButton setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
  }
}

#pragma mark - Notification Receivers

-(void)updateUserData:(NSNotification *)notification {
  
//  profilePic.image = (UIImage *)notification.userInfo[@"profilePic"];
//  headerImageView.image = (UIImage *)notification.userInfo[@"headerBGImage"];
//  dispatch_async(dispatch_get_global_queue(0,0), ^{
//    [self loadUserDetails];
//  });
}

-(void) friendStatusUpdatedNotificationReceived:(NSNotification *)notification {
  
  NSLog(@"friendStatusUpdatedNotificationReceived");
  LCFriend *friend = notification.userInfo[@"friend"];
  if (currentProfileStatus == kMyProfile) {
    
    if (notification.name == kAcceptFriendRequestNFK) {
      
      NSInteger count = [_userDetail.friendCount integerValue] - 1;
      _userDetail.friendCount = [NSString stringWithFormat: @"%ld", (long)count];
      friendsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:_userDetail.friendCount];
    }
    else if(notification.name == kRemoveFriendNFK) {
      
      NSInteger count = [_userDetail.friendCount integerValue] + 1;
      _userDetail.friendCount = [NSString stringWithFormat: @"%ld", (long)count];
      friendsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:_userDetail.friendCount];
    }
  }
  else if(_userDetail.userID == friend.friendId) {
    
    _userDetail.isFriend = friend.isFriend;
    [self setCurrentProfileStatus:(FriendStatus)[_userDetail.isFriend integerValue]];
  }
}


-(void)updateImpactsCount:(NSNotification *)notification {
  
  if (currentProfileStatus == kMyProfile) {
    
    if (notification.name == kCreateNewPostNFK) {
      
      NSInteger count = [_userDetail.impactCount integerValue] + 1;
      _userDetail.impactCount = [NSString stringWithFormat: @"%ld", (long)count];
      impactsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:_userDetail.impactCount];
    }
    else if (notification.name == kDeletePostNFK) {
      
      NSInteger count = [_userDetail.impactCount integerValue] - 1;
      _userDetail.impactCount = [NSString stringWithFormat: @"%ld", (long)count];
      impactsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:_userDetail.impactCount];
    }
  }
}
@end
