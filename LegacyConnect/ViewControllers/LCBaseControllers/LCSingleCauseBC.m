//
//  LCSingleCauseBC.m
//  LegacyConnect
//
//  Created by Jijo on 1/15/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCSingleCauseBC.h"

@interface LCSingleCauseBC ()

@end

@implementation LCSingleCauseBC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kLikedPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kUnlikedPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kCommentPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kUpdatePostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedDeletedNotificationReceived:) name:kDeletePostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPostCreatedNotificationReceived:) name:kCreateNewPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedReportedNotificationReceived:) name:kReportedPostNFK object:nil];
  
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileNotificationReceived:) name:kUpdateProfileNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kRemoveMileStoneNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(causeNotificationReceived:) name:kSupportCauseNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(causeNotificationReceived:) name:kUnsupportCauseNFK object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interestUnfollowNotificationReceived:) name:kUnfollowInterestNFK object:nil];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)interestUnfollowNotificationReceived: (NSNotification *)notification
{
  LCInterest *updatedInterest = [notification.userInfo objectForKey:kInterestObj];
  if ([self.cause.interestID isEqualToString:updatedInterest.interestID] && self.cause.isSupporting) {
    self.cause.isSupporting = NO;
    self.cause.supporters = [NSString stringWithFormat:@"%d",[self.cause.supporters intValue]-1];
    [self refreshViews];
  }
}

- (void)newPostCreatedNotificationReceived :(NSNotification *)notification
{
  LCFeed *newPost = notification.userInfo[@"post"];
  if (![self.cause.causeID isEqualToString:newPost.postToID]) {
    return;
  }
  [self.results insertObject:newPost atIndex:0];
  [self refreshViews];
}


- (void)feedDeletedNotificationReceived :(NSNotification *)notification
{
  LCFeed *newfeed = [notification.userInfo objectForKey:@"post"];
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCFeed class]]) {
      LCFeed *feed = self.results[i];
      if ([feed.entityID isEqualToString:newfeed.entityID])
      {
        [self.results removeObjectAtIndex:i];
        break;
      }
    }
  }
  [self refreshViews];
}

//- (void)updateProfileNotificationReceived :(NSNotification *)notification
//{
  //  firstName;
  //  lastName;
  //  avatarURL;
//}

- (void)feedUpdatedNotificationReceived :(NSNotification *)notification
{
  LCFeed *newfeed = [notification.userInfo objectForKey:@"post"];
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCFeed class]]) {
      LCFeed *feed = self.results[i];
      if ([feed.entityID isEqualToString:newfeed.entityID])
      {
        [self.results replaceObjectAtIndex:i withObject:newfeed];
        break;
      }
    }
  }
  [self refreshViews];
}

- (void)causeNotificationReceived :(NSNotification *)notification
{
  LCCause *cause = notification.userInfo[kCauseObj];
  self.cause = cause;
  [self refreshViews];
}

- (void)feedReportedNotificationReceived :(NSNotification *)notification
{
  LCFeed *newfeed = notification.userInfo[kEntityTypePost];
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCFeed class]]) {
      LCFeed *feed = self.results[i];
      if ([feed.entityID isEqualToString:newfeed.entityID])
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
  CGPoint offset = self.tableView.contentOffset;
  [self reloadPostsTable];
  [self.tableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
  [self.tableView setContentOffset:offset];
  [self setNoResultViewHidden:[self.results count] != 0];
  [self refreshViewWithCauseDetails];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshViews];
}


- (void)setNoResultViewHidden:(BOOL)hidded
{
  if (hidded) {
    [self hideNoResultsView];
  }
  else{
    [self showNoResultsView];
  }
}

- (void)reloadPostsTable
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    //    [self.tableView layoutIfNeeded];
    //    if (self.tableView.contentSize.height>self.tableView.frame.size.height - [LCUtilityManager getHeightOffsetForGIB]) {
    //      self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+[LCUtilityManager getHeightOffsetForGIB]);
    //    }
  });
}

-(void)refreshViewWithCauseDetails
{
  self.causeDescriptionLabel.text = [LCUtilityManager performNullCheckAndSetValue:self.cause.tagLine];
  self.navigationBar.title.text =[[LCUtilityManager performNullCheckAndSetValue: self.cause.name] uppercaseString];
  [self.causeImageView sd_setImageWithURL:[NSURL URLWithString:self.cause.logoURLSmall] placeholderImage:[UIImage imageNamed:@"cause_placeholder"]];
  self.causeNameLabel.text = [[LCUtilityManager performNullCheckAndSetValue:self.cause.name] uppercaseString];
  [self.causeSupportersCountButton setTitle:[NSString stringWithFormat:@"%@ Followers",[LCUtilityManager performNullCheckAndSetValue:self.cause.supporters]] forState:UIControlStateNormal];
  
  [self.causeURLButton setTitle:[LCUtilityManager performNullCheckAndSetValue:self.cause.causeUrl] forState:UIControlStateNormal];
  
  if(self.cause.isSupporting)
  {
    [self.supportButton setSelected:YES];
  }
  else
  {
    [self.supportButton setSelected:NO];
  }
}


@end
