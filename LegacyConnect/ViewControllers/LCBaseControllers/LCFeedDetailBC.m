//
//  LCFeedDetailBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

/* notifications to be handled
 1: liked a post : <Implemented>
 2: unliked post : <Implemented>
 3: commented a post - comment should be added to table and count should be increased : <Implemented>
 4: Updated a post :
 5: deleted a post - not included now as it will affect the navigation flow
 6: user profile updated
 7: remove milestone - if milestone icon is shown in feed detail
 */

#import "LCFeedDetailBC.h"

@implementation LCFeedDetailBC

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postLikeEventReceived:) name:kLikedPostNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postUnLikeEventReceived:) name:kUnlikedPostNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommentEventReceived:) name:kCommentPostNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postUpdateEventReceived:) name:kUpdatePostNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdateEventReceived:) name:kUpdateProfileNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(milestoneRemovedEventReceived:) name:kRemoveMileStoneNFK object:nil];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshFeedDetails];
}

#pragma mark - Private method implementation
- (void)refreshFeedDetails
{
  [self.tableView reloadData];
}

- (void)topViewOnlyRefresh
{
  if (self.isViewLoaded && self.view.window) {
    [self refreshFeedDetails];
  }
}

#pragma maek - Notification handling.
- (void)postLikeEventReceived:(NSNotification*)notification
{
  LCFeed *updatedFeed = [notification.userInfo objectForKey:kEntityTypePost];
  if ([self.feedObject.entityID isEqualToString:updatedFeed.entityID]) {
    self.feedObject.likeCount = updatedFeed.likeCount;
    self.feedObject.didLike = updatedFeed.didLike;
    
    [self topViewOnlyRefresh];
  }
}

- (void)postUnLikeEventReceived:(NSNotification*)notification
{
  LCFeed *updatedFeed = [notification.userInfo objectForKey:kEntityTypePost];
  if ([self.feedObject.entityID isEqualToString:updatedFeed.entityID]) {
    self.feedObject.likeCount = updatedFeed.likeCount;
    self.feedObject.didLike = updatedFeed.didLike;
    
    [self topViewOnlyRefresh];
  }
}

- (void)postCommentEventReceived:(NSNotification*)notification
{
  LCFeed * feed = [notification.userInfo objectForKey:kEntityTypePost];
  LCComment *newComment = [notification.userInfo objectForKey:kPostCommentKey];
  if ([self.feedObject.entityID isEqualToString:feed.entityID]) {
    [self.results insertObject:newComment atIndex:0];
    self.feedObject.commentCount = feed.commentCount;

    [self topViewOnlyRefresh];
  }
}

- (void)postUpdateEventReceived:(NSNotification*)notification
{
  LCFeed *updatedFeed = [notification.userInfo objectForKey:kEntityTypePost];
  if ([self.feedObject.feedId isEqualToString:updatedFeed.feedId]) {
    self.feedObject = updatedFeed;
    
    [self topViewOnlyRefresh];
  }
}

- (void)profileUpdateEventReceived:(NSNotification*)notification
{
  
}

- (void)milestoneRemovedEventReceived:(NSNotification*)notification
{
  LCFeed *updatedFeed = [notification.userInfo objectForKey:kEntityTypePost];
  if ([self.feedObject.feedId isEqualToString:updatedFeed.feedId]) {
    self.feedObject.isMilestone = updatedFeed.isMilestone;
    
    [self topViewOnlyRefresh];
  }
}


@end
