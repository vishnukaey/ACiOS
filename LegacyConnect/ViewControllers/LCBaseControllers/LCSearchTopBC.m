//
//  LCSearchTopBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/17/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSearchTopBC.h"

@interface LCSearchTopBC ()

@end

@implementation LCSearchTopBC

#pragma mark - view life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  
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
                                           selector:@selector(friendStatusUpdatedNotificationReceived:)
                                               name:kBlockUserNFK
                                             object:nil];

  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(interestFollowedNotificationReceived:)
                                               name:kFollowInterestNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(interestUnfollowedNotificationReceived:)
                                               name:kUnfollowInterestNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(causeNotificationReceived:)
                                               name:kSupportCauseNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(causeNotificationReceived:)
                                               name:kUnsupportCauseNFK object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)friendStatusUpdatedNotificationReceived :(NSNotification *)notification
{
  LCFriend *newFriend = notification.userInfo[@"friend"];
  for (int i = 0; i<self.searchResultObject.usersArray.count ; i++) {
    if ([self.searchResultObject.usersArray[i] isKindOfClass:[LCUserDetail class]]) {
      LCUserDetail *friend = self.searchResultObject.usersArray[i];
      if ([friend.userID isEqualToString:newFriend.friendId])
      {
        friend.isFriend = newFriend.isFriend;
        break;
      }
    }
  }
  [self.topTableView reloadData];
}

- (void)interestFollowedNotificationReceived :(NSNotification *)notification
{
  LCInterest *updatedInterest = [notification.userInfo objectForKey:kInterestObj];
  for (int i = 0; i<self.searchResultObject.interestsArray.count ; i++) {
    if ([self.searchResultObject.interestsArray[i] isKindOfClass:[LCInterest class]]) {
      LCInterest *interest = self.searchResultObject.interestsArray[i];
      if ([interest.interestID isEqualToString:updatedInterest.interestID])
      {
        interest.isFollowing = updatedInterest.isFollowing;
        interest.followers = updatedInterest.followers;
        break;
      }
    }
  }
  [self.topTableView reloadData];
}

- (void)interestUnfollowedNotificationReceived :(NSNotification *)notification
{
  LCInterest *updatedInterest = [notification.userInfo objectForKey:kInterestObj];
  for (int i = 0; i<self.searchResultObject.interestsArray.count ; i++) {
    if ([self.searchResultObject.interestsArray[i] isKindOfClass:[LCInterest class]]) {
      LCInterest *interest = self.searchResultObject.interestsArray[i];
      if ([interest.interestID isEqualToString:updatedInterest.interestID])
      {
        interest.isFollowing = updatedInterest.isFollowing;
        interest.followers = updatedInterest.followers;
        break;
      }
    }
  }
  [self.topTableView reloadData];
}


- (void)causeNotificationReceived :(NSNotification *)notification
{
  LCCause *updatedCause = [notification.userInfo objectForKey:kCauseObj];
  for (int i = 0; i<self.searchResultObject.causesArray.count ; i++) {
    if ([self.searchResultObject.causesArray[i] isKindOfClass:[LCCause class]]) {
      LCCause *cause = self.searchResultObject.causesArray[i];
      if ([cause.interestID isEqualToString:updatedCause.interestID])
      {
        cause.isSupporting = updatedCause.isSupporting;
        cause.supporters = updatedCause.supporters;
        break;
      }
    }
  }
  [self.topTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
