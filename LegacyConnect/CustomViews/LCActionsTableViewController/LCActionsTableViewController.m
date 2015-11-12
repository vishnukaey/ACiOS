//
//  LCActionsTableTableViewController.m
//  LegacyConnect
//
//  Created by qbuser on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCActionsTableViewController.h"

@interface LCActionsTableViewController ()

@end

@implementation LCActionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventUpdatedNotificationReceived:) name:kEventDetailsUpdatedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDeletedNotificationReceived:) name:kEventDeletedNotification object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)eventUpdatedNotificationReceived :(NSNotification *)notification
{
  LCEvent *modifiedEvent = [notification.userInfo objectForKey:@"event"];
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCEvent class]]) {
      LCEvent *event = self.results[i];
      if ([event.eventID isEqualToString:modifiedEvent.eventID])
      {
        [self.results replaceObjectAtIndex:i withObject:modifiedEvent];
        break;
      }
    }
  }
  [self.tableView reloadData];
}

- (void)eventDeletedNotificationReceived :(NSNotification *)notification
{
  LCEvent *deletedEvent = [notification.userInfo objectForKey:@"event"];
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCEvent class]]) {
      LCEvent *event = self.results[i];
      if ([event.eventID isEqualToString:deletedEvent.eventID])
      {
        [self.results removeObjectAtIndex:i];
        break;
      }
    }
  }
  [self.tableView reloadData];
}

@end
