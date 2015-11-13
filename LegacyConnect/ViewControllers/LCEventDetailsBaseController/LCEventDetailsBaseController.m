//
//  LCEventDetailsBaseController.m
//  LegacyConnect
//
//  Created by qbuser on 09/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCEventDetailsBaseController.h"

@implementation LCEventDetailsBaseController

#pragma mark - view life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self addEventMembersUpdateNotificationObserver];
  [self addEventDetailsUpdatdeNotificationObserver];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc
{
  [self removeEventMembersUpdateNotificationObserver];
  [self removeEventDetailsUpdatedNotificationObserver];
}

- (void)refreshEventDetails
{
  
}

#pragma mark - 
#pragma mark - Event member count updated actions
- (void)addEventMembersUpdateNotificationObserver
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventMembersCountUpdated:) name:kEventMemberCountUpdatedNotification object:nil];
}

- (void)removeEventMembersUpdateNotificationObserver
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kEventMemberCountUpdatedNotification object:nil];
}

- (void)eventMembersCountUpdated:(NSNotification*)notification
{
  NSDictionary * userInfo = notification.userInfo;
  LCEvent *modifiedEvent = [userInfo objectForKey:@"event"];
  if ([self.eventObject.eventID isEqualToString:modifiedEvent.eventID]) {
    self.eventObject.isFollowing = modifiedEvent.isFollowing;
    self.eventObject.followerCount = modifiedEvent.followerCount;
    if (self.eventObject.isFollowing) {
      [settingsButton setTitle:NSLocalizedString(@"attending", @"Attending button title") forState:UIControlStateNormal];
      [self showCommentsField];
    } else {
      [settingsButton setTitle:NSLocalizedString(@"attend", @"attend button title") forState:UIControlStateNormal];
      [self hideCommentsFields];
      [self.results removeAllObjects];
    }
    [self.tableView reloadData];
  }
}

#pragma mark - Event details updated actions
- (void)addEventDetailsUpdatdeNotificationObserver
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDetailsUpdated:) name:kEventDetailsUpdatedNotification object:nil];
}

- (void)removeEventDetailsUpdatedNotificationObserver
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kEventDetailsUpdatedNotification object:nil];
}

- (void)eventDetailsUpdated:(NSNotification*)notification
{
  NSDictionary * userInfo = notification.userInfo;
  LCEvent *modifiedEvent = [userInfo objectForKey:@"event"];
  if ([self.eventObject.eventID isEqualToString:modifiedEvent.eventID]) {
    self.eventObject = modifiedEvent;
    [self refreshEventDetails];
    [self.tableView reloadData];
  }
}

@end
