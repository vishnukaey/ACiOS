//
//  LCFriendsListBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//
/* notifications to be handled
 1: unfriend - remove from table ***handled***
 2: accepted request - if mandatory
 */
#import "LCFriendsListBC.h"

@interface LCFriendsListBC ()

@end

@implementation LCFriendsListBC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(friendRemovedNotificationReceived:)
                                               name:kRemoveFriendNFK
                                             object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(friendAcceptedNotificationReceived:)
//                                               name:kAcceptFriendRequestNFK
//                                             object:nil];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)friendRemovedNotificationReceived :(NSNotification *)notification
{
  LCFriend *newFriend = notification.userInfo[@"friend"];
  if ([self.userId isEqualToString:newFriend.friendId])
  {
    for (int i = 0; i<self.results.count ; i++) {
      if ([self.results[i] isKindOfClass:[LCFriend class]]) {
        LCFriend *friend = self.results[i];
        if ([friend.friendId isEqualToString:[LCDataManager sharedDataManager].userID])
        {
          [self.results removeObjectAtIndex:i];
          break;
        }
      }
    }
  }
  else if ([self.userId isEqualToString:[LCDataManager sharedDataManager].userID])
  {
    for (int i = 0; i<self.results.count ; i++) {
      if ([self.results[i] isKindOfClass:[LCFriend class]]) {
        LCFriend *friend = self.results[i];
        if ([friend.friendId isEqualToString:newFriend.friendId])
        {
          [self.results removeObjectAtIndex:i];
          break;
        }
      }
    }
  }
  [self refreshViews];
}


//- (void)friendAcceptedNotificationReceived :(NSNotification *)notification
//{
//  LCFriend *newFriend = notification.userInfo[@"friend"];
//  [self.results addObject:newFriend];
//  [self refreshViews];
//}

- (void)refreshViews
{
  if ([self.navigationController.topViewController isEqual:self]) {
    CGPoint offset = self.tableView.contentOffset;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self.tableView setContentOffset:offset];
    [self setNoResultViewHidden:[self.results count] != 0];
  }
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshViews];
}

- (void)setNoResultViewHidden:(BOOL)hidded
{
  if (hidded) {
    [self hideNoResultsView];
  }
  else{
    [self showNoResultsView];
  }
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
