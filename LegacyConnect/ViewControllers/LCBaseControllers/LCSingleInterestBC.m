//
//  LCSingleInterestBC.m
//  LegacyConnect
//
//  Created by Jijo on 1/13/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCSingleInterestBC.h"

@interface LCSingleInterestBC ()

@end

@implementation LCSingleInterestBC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDeletedNotificationReceived:) name:kDeleteEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventCreatedNotificationReceived:) name:kCreateEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interestFollowedNotificationReceived:) name:kFollowInterestNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interestUnfollowedNotificationReceived:) name:kUnfollowInterestNFK object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Private Methods

- (void) updateInterestDetails
{
  interestName.text = [[LCUtilityManager performNullCheckAndSetValue:self.interest.name] uppercaseString];
  interestDescription.text = [LCUtilityManager performNullCheckAndSetValue:self.interest.descriptionText];
  followersCount.text = [LCUtilityManager performNullCheckAndSetValue:self.interest.followers];
  actionsCount.text = [LCUtilityManager performNullCheckAndSetValue:self.interest.events];
  [interestFollowButton setSelected:self.interest.isFollowing];
}


#pragma mark Notification Receiveres

- (void)eventDeletedNotificationReceived :(NSNotification *)notification
{
  LCEvent *deletedEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
  if ([self.interest.interestID isEqualToString:deletedEvent.interestID]) {
    NSInteger actions = [self.interest.events integerValue] - 1 ;
    self.interest.events = [NSString stringWithFormat:@"%d", actions];
    [self updateInterestDetails];
  }
}

- (void)eventCreatedNotificationReceived :(NSNotification *)notification
{
  LCEvent *createdEvent = [notification.userInfo objectForKey:kEntityTypeEvent];
  if ([self.interest.interestID isEqualToString:createdEvent.interestID]) {
    NSInteger actions = [self.interest.events integerValue] + 1 ;
    self.interest.events = [NSString stringWithFormat:@"%d", actions];
    [self updateInterestDetails];
  }
}

- (void)interestFollowedNotificationReceived :(NSNotification *)notification
{
  LCInterest *updatedInterest = [notification.userInfo objectForKey:kInterestObj];
  if ([self.interest.interestID isEqualToString:updatedInterest.interestID]) {
    self.interest = updatedInterest;
    [self updateInterestDetails];
  }
}

- (void)interestUnfollowedNotificationReceived :(NSNotification *)notification
{
  LCInterest *updatedInterest = [notification.userInfo objectForKey:kInterestObj];
  if ([self.interest.interestID isEqualToString:updatedInterest.interestID]) {
    self.interest = updatedInterest;
    [self updateInterestDetails];
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
