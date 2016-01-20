//
//  LCInterestActionsBC.m
//  LegacyConnect
//
//  Created by Jijo on 1/13/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCInterestActionsBC.h"

@interface LCInterestActionsBC ()

@end

@implementation LCInterestActionsBC

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventUpdatedNotificationReceived:) name:kUpdateEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDeletedNotificationReceived:) name:kDeleteEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventCreatedNotificationReceived:) name:kCreateEventNFK object:nil];
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

- (void)eventCreatedNotificationReceived :(NSNotification *)notification
{
  LCEvent *createdEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
  if ([createdEvent.interestID isEqualToString:self.interest.interestID]) {
    [self.results insertObject:createdEvent atIndex:0];
    [self refreshTopViewOnly];
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
