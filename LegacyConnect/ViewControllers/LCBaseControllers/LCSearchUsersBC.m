//
//  LCSearchUsersBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/17/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSearchUsersBC.h"

@interface LCSearchUsersBC ()

@end

@implementation LCSearchUsersBC

#pragma mark - view life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendStatusUpdatedNotificationReceived:) name:friendStatusUpdatedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:friendStatusUpdatedNotification object:nil];
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
  [self.tableView reloadData];
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
