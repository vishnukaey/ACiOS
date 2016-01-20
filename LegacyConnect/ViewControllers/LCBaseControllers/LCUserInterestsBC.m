//
//  LCUserInterestsBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//
/* notifications to be handled
 1: followed an interest
 2: unfollowed an interest
 */

#import "LCUserInterestsBC.h"

@interface LCUserInterestsBC ()

@end

@implementation LCUserInterestsBC

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interestFollowed:) name:kFollowInterestNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interestUnFollowed:) name:kUnfollowInterestNFK object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshMyInterestListing];
}

- (void)refreshMyInterestListing
{
  [self.tableView reloadData];
}

- (void)refreshTopViewOnly
{
  if (self.view.window) {
    [self refreshMyInterestListing];
  }
}

- (void)interestFollowed:(NSNotification*)notification
{
  LCInterest *newInterest = [notification.userInfo objectForKey:kInterestObj];
  [self.results insertObject:newInterest atIndex:0];
  [self refreshTopViewOnly];
}

- (void)interestUnFollowed:(NSNotification*)notification
{
  LCInterest *newInterest = [notification.userInfo objectForKey:kInterestObj];
  for (int i = 0; i <self.results.count ; i++) {
    LCInterest *interest = self.results[i];
    if ([interest.interestID isEqualToString:newInterest.interestID]) {
      [self.results removeObjectAtIndex:i];
      [self refreshTopViewOnly];
    }
  }
}

@end
