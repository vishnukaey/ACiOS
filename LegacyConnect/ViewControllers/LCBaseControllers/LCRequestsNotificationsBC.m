//
//  LCRequestsNotificationsBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/26/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCRequestsNotificationsBC.h"

@interface LCRequestsNotificationsBC ()

@end

@implementation LCRequestsNotificationsBC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendRequestUpdatedNotificationReceived:) name:kAcceptFriendRequestNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendRequestUpdatedNotificationReceived:) name:kRejectFriendRequestNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventRequestUpdatedNotificationReceived:) name:kAcceptEventRequestNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventRequestUpdatedNotificationReceived:) name:kRejectEventRequestNFK object:nil];
}

- (void)friendRequestUpdatedNotificationReceived :(NSNotification *)notification
{
  if (self.isViewLoaded && self.view.window)//animation handling in subclass
  {
    return;
  }
  LCFriend *updated_friend = notification.userInfo[@"friend"];
    for (int i = 0; i<self.results.count ; i++) {
      if ([self.results[i] isKindOfClass:[LCRequest class]]) {
        LCRequest *request__ = self.results[i];
        if (![request__.type isEqualToString:@"event"] && [request__.friendID isEqualToString:updated_friend.friendId]) {
            [self.results removeObjectAtIndex:i];
            break;
        }
      }
    }
  [self refreshViews];
}

- (void)eventRequestUpdatedNotificationReceived :(NSNotification *)notification
{
  if (self.isViewLoaded && self.view.window)//animation handling in subclass
  {
    return;
  }
  LCEvent *updated_event = notification.userInfo[@"event"];
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCRequest class]]) {
      LCRequest *request__ = self.results[i];
      if ([request__.type isEqualToString:@"event"] && [request__.eventID isEqualToString:updated_event.eventID])
      {
          [self.results removeObjectAtIndex:i];
          break;
      }
    }
  }
  [self refreshViews];
}


- (void)refreshViews
{
    // viewController is visible
    CGPoint offset = self.tableView.contentOffset;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self.tableView setContentOffset:offset];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
