//
//  LCUsersListBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//
/* notifications to be handled
 1: profile updated
 2: send friend request
 3: cancel friend request
 4: unfriend
 */
#import "LCUsersListBC.h"

@interface LCUsersListBC ()

@end

@implementation LCUsersListBC

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
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCUserDetail class]]) {
      LCUserDetail *friend = self.results[i];
      if ([friend.userID isEqualToString:newFriend.friendId])
      {
        friend.isFriend = newFriend.isFriend;
        break;
      }
    }
  }
  [self refreshViews];
}

- (void)refreshViews
{
    CGPoint offset = self.tableView.contentOffset;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self.tableView setContentOffset:offset];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshViews];
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
