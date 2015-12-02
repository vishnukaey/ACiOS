//
//  LCEventDetailsBaseController.m
//  LegacyConnect
//
//  Created by qbuser on 09/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//
/* notifications to be handled
 1: attend event        : <Implemented>
 2: unattend event      : <Implemented>
 3: edit event          : <Implemented>
 4: delete event        *Not Implemented*
 5: commented a post -  : <Implemented>
 */

#import "LCEventDetailsBC.h"

@implementation LCEventDetailsBC

#pragma mark - view life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventFollowNotificationReceived:) name:kFollowEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventUnFollowNotificationReceived:) name:kUnfollowEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDetailsUpdatedNotificationReceived:) name:kUpdateEventNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventCommentedNotificationReceived:) name:kCommentEventNFK object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshEventDetails];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshEventDetails
{
  //-- This is implemented in child view controllers.
}

- (void)dataPopulation
{
  //-- This is implemented in child view controllers.
}
- (void)topViewOnlyRefresh
{
  if (self.isViewLoaded && self.view.window) {
    [self dataPopulation];
  } else {
    self.needCommentRefresh = YES;
  }
}

#pragma mark - 
#pragma mark - Event member count updated actions

- (void)eventFollowNotificationReceived:(NSNotification*)notification
{
  NSDictionary * userInfo = notification.userInfo;
  LCEvent *modifiedEvent = [userInfo objectForKey:kEntityTypeEvent];
  if ([self.eventObject.eventID isEqualToString:modifiedEvent.eventID]) {
    self.eventObject.isFollowing = modifiedEvent.isFollowing;
    self.eventObject.followerCount = modifiedEvent.followerCount;
    [settingsButton setTitle:NSLocalizedString(@"attending", @"Attending button title") forState:UIControlStateNormal];
    [self showCommentsField];
    
    [self topViewOnlyRefresh];
  }
}

- (void)eventUnFollowNotificationReceived:(NSNotification*)notification
{
  NSDictionary * userInfo = notification.userInfo;
  LCEvent *modifiedEvent = [userInfo objectForKey:kEntityTypeEvent];
  if ([self.eventObject.eventID isEqualToString:modifiedEvent.eventID]) {
    self.eventObject.isFollowing = modifiedEvent.isFollowing;
    self.eventObject.followerCount = modifiedEvent.followerCount;
    [settingsButton setTitle:NSLocalizedString(@"attend", @"attend button title") forState:UIControlStateNormal];
    [self hideCommentsFields];
    
    [self topViewOnlyRefresh];
  }
}

#pragma mark - Event details updated actions
- (void)eventDetailsUpdatedNotificationReceived:(NSNotification*)notification
{
  NSDictionary * userInfo = notification.userInfo;
  LCEvent *modifiedEvent = [userInfo objectForKey:kEntityTypeEvent];
  if ([self.eventObject.eventID isEqualToString:modifiedEvent.eventID]) {
    self.eventObject = modifiedEvent;
    [self topViewOnlyRefresh];
  }
}

- (void)eventCommentedNotificationReceived:(NSNotification*)notification
{
  NSDictionary * userInfo = notification.userInfo;
  LCEvent * event = userInfo[kEntityTypeEvent];
  LCComment *newComment = userInfo[kPostCommentKey];
  if ([self.eventObject.eventID isEqualToString:event.eventID]) {
    [self.results insertObject:newComment atIndex:0];
    
    [self topViewOnlyRefresh];
  }

}

@end
