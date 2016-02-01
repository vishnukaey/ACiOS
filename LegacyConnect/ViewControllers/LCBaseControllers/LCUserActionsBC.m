//
//  LCActionsTableTableViewController.m
//  LegacyConnect
//
//  Created by qbuser on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//
/* notifications to be handled
 1: updated an action - if self profile
 2: deleted an action - if self profile
 3: attend an action - if self profile
 4: created an action - if self profile
 5: un attend an action - if self profile
 */

#import "LCUserActionsBC.h"

@interface LCUserActionsBC ()

@end

@implementation LCUserActionsBC

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventUpdatedNotificationReceived:) name:kUpdateEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDeletedNotificationReceived:) name:kDeleteEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventCreatedNotificationReceived:) name:kCreateEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventFollowedNotificationReceived:) name:kFollowEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventUnFollowedNotificationReceived:) name:kUnfollowEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventReportedNotificationReceived:) name:kReportedEventNFK object:nil];
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
  [self refreshEventListing];
}

- (void)refreshEventListing
{
  [self.tableView reloadData];
}

- (void)refreshTopViewOnly
{
  if (self.view.window) {
    [self refreshEventListing];
  }
}

- (void)eventUpdatedNotificationReceived :(NSNotification *)notification
{
  LCEvent *modifiedEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
  for (int i = 0; i<self.results.count ; i++) {
    LCEvent *event = self.results[i];
    if ([event.eventID isEqualToString:modifiedEvent.eventID])
    {
      [self.results replaceObjectAtIndex:i withObject:modifiedEvent];
      [self refreshTopViewOnly];
      break;
    }
  }
}

- (void)eventDeletedNotificationReceived :(NSNotification *)notification
{
  LCEvent *deletedEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
  for (int i = 0; i<self.results.count ; i++) {
    LCEvent *event = self.results[i];
    if ([event.eventID isEqualToString:deletedEvent.eventID])
    {
      [self.results removeObjectAtIndex:i];
      [self refreshTopViewOnly];
      break;
    }
  }
}

- (void)eventReportedNotificationReceived :(NSNotification *)notification
{
  LCEvent *deletedEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
  for (int i = 0; i<self.results.count ; i++) {
    LCEvent *event = self.results[i];
    if ([event.eventID isEqualToString:deletedEvent.eventID])
    {
      [self.results removeObjectAtIndex:i];
      [self refreshTopViewOnly];
      break;
    }
  }
}


- (void)eventCreatedNotificationReceived :(NSNotification *)notification
{
  if (isSelfProfile) {
    LCEvent *createdEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
    [self.results insertObject:createdEvent atIndex:0];
    [self refreshTopViewOnly];
  }
}

- (void)eventFollowedNotificationReceived :(NSNotification *)notification
{
  LCEvent *followedEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
  if (isSelfProfile) {
    [self.results insertObject:followedEvent atIndex:0];
  }
  else
  {
    for (int i = 0; i<self.results.count ; i++) {
      if ([self.results[i] isKindOfClass:[LCEvent class]]) {
        LCEvent *event = self.results[i];
        if ([event.eventID isEqualToString:followedEvent.eventID])
        {
          event.followerCount = [NSString stringWithFormat:@"%ld", [event.followerCount integerValue]+1];
          break;
        }
      }
    }
  }
  [self refreshTopViewOnly];
}

- (void)eventUnFollowedNotificationReceived :(NSNotification *)notification
{
  
    LCEvent *unFollowedEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
    for (int i = 0; i<self.results.count ; i++) {
      LCEvent *event = self.results[i];
      if ([event.eventID isEqualToString:unFollowedEvent.eventID])
      {
        if (isSelfProfile) {
          [self.results removeObjectAtIndex:i];
        }
        else
        {
          event.followerCount = [NSString stringWithFormat:@"%ld", [event.followerCount integerValue]-1];
        }
        [self refreshTopViewOnly];
        break;
      }
    }
}

@end
