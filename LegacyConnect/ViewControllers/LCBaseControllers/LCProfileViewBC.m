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

  //hide until privacy check
  tabBarView.hidden = YES;
  impactsCountButton.userInteractionEnabled = NO;
  friendsCountButton.userInteractionEnabled = NO;
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(profileUpdatedNotificationReceived:)
                                               name:kUpdateProfileNFK
                                             object:nil];
  
  
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
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateImpactsCount:)
                                               name:kReportedPostNFK
                                             object:nil];
}

- (void)dealloc {
  
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

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
    case kBlocked:
      btnImageName = kImageNameProfileAdd;
      break;
  }
  if(btnImageName)
  {
    [friendsButton setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
  }
}

- (void) updateUserDetailUI {
  
  userNameLabel.text = [[NSString stringWithFormat:@"%@ %@",
                         [LCUtilityManager performNullCheckAndSetValue:self.userDetail.firstName],
                         [LCUtilityManager performNullCheckAndSetValue:self.userDetail.lastName]] uppercaseString];
  memeberSincelabel.text = [NSString stringWithFormat:@"%@ %@",
                            NSLocalizedString(@"member_since", nil),
                            [LCUtilityManager getDateFromTimeStamp:self.userDetail.activationDate WithFormat:@"YYYY"]];
  
  locationLabel.text = [[NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                         [LCUtilityManager performNullCheckAndSetValue:self.userDetail.gender],
                         kBulletUnicode,
                         [LCUtilityManager getAgeFromTimeStamp:self.userDetail.dob],
                         kBulletUnicode,
                         [LCUtilityManager performNullCheckAndSetValue:self.userDetail.location]] uppercaseString];
  
  impactsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:self.userDetail.impactCount];
  friendsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:self.userDetail.friendCount];
  
  NSString *profileUrlString = [NSString stringWithFormat:@"%@?type=large",self.userDetail.avatarURL];
  [profilePic sd_setImageWithURL:[NSURL URLWithString:profileUrlString]
                placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  
  [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.userDetail.headerPhotoURL]
                     placeholderImage:nil];
  
  [self setCurrentProfileStatus:(FriendStatus)[self.userDetail.isFriend integerValue]];
}

- (void) checkPrivacySettings {
  
  if (currentProfileStatus != kMyProfile) {
    
    NSInteger privacy = [self.userDetail.privacy integerValue];
    if (privacy == kPivacyPublic ||
        (privacy == kPivacyFriendsOnly && [self.userDetail.isFriend integerValue] == kIsFriend)) {
      [self showTabBarAndLoadMilestones];
    }
  }
}

- (void) showTabBarAndLoadMilestones {
  
  tabBarView.hidden = NO;
  impactsCountButton.userInteractionEnabled = YES;
  friendsCountButton.userInteractionEnabled = YES;
  [mileStonesVC loadMileStones];
}

#pragma mark - Notification Receivers

-(void)profileUpdatedNotificationReceived:(NSNotification *)notification {

   _userDetail = notification.userInfo[@"userDetail"];
  [self updateUserDetailUI];
  [LCUtilityManager saveUserDetailsToDataManagerFromResponse:_userDetail];
}

-(void) friendStatusUpdatedNotificationReceived:(NSNotification *)notification {
  
  LCFriend *friend = notification.userInfo[@"friend"];
  if (currentProfileStatus == kMyProfile || _userDetail.userID == friend.friendId) {
  
    if(_userDetail.userID == friend.friendId) {
      
      _userDetail.isFriend = friend.isFriend;
    }
    
    if (notification.name == kAcceptFriendRequestNFK) {
      
      NSInteger count = [_userDetail.friendCount integerValue] + 1;
      _userDetail.friendCount = [NSString stringWithFormat: @"%ld", (long)count];
      [self checkPrivacySettings];
    }
    else if(notification.name == kRemoveFriendNFK) {
      
      NSInteger count = [_userDetail.friendCount integerValue] - 1;
      _userDetail.friendCount = [NSString stringWithFormat: @"%ld", (long)count];
    }
    [self updateUserDetailUI];
  }
}


-(void)updateImpactsCount:(NSNotification *)notification {
  
  if (currentProfileStatus == kMyProfile) {
    
    if (notification.name == kCreateNewPostNFK) {
      
      NSInteger count = [_userDetail.impactCount integerValue] + 1;
      _userDetail.impactCount = [NSString stringWithFormat: @"%ld", (long)count];
    }
    else if (notification.name == kDeletePostNFK) {
      
      NSInteger count = [_userDetail.impactCount integerValue] - 1;
      _userDetail.impactCount = [NSString stringWithFormat: @"%ld", (long)count];
    }
  }
  else
  {
    if (notification.name == kReportedPostNFK) {
      
      NSInteger count = [_userDetail.impactCount integerValue] - 1;
      _userDetail.impactCount = [NSString stringWithFormat: @"%ld", (long)count];
    }
  }
  [self updateUserDetailUI];
}
@end
