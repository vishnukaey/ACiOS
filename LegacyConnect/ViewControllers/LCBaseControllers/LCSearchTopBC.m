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
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendStatusUpdatedNotificationReceived:) name:kFriendStatusUpdatedNFK object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kFriendStatusUpdatedNFK object:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
