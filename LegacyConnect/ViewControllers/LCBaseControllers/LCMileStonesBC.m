//
//  LCmileStonesBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//
/* notifications to be handled
 1: liked a post
 2: unliked post
 3: commented a post
 4: Updated a post - if self profile
 5: deleted a post - if self profile
 6: created new post - if milestone and self profile
 7: user profile updated -  should handle if mandatory, else if server dosent reflect the changes it may cause confusion
 8: remove milestone - if self profile
 */

#import "LCMileStonesBC.h"

@interface LCMileStonesBC ()

@end

@implementation LCMileStonesBC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kLikedPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kUnlikedPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kCommentPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedEditedNotificationReceived:) name:kUpdatePostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedDeletedNotificationReceived:) name:kDeletePostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPostCreatedNotificationReceived:) name:kCreateNewPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileNotificationReceived:) name:kUpdateProfileNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(milestoneRemovedNotificationReceived:) name:kRemoveMileStoneNFK object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)newPostCreatedNotificationReceived :(NSNotification *)notification
{
  LCFeed *newPost = notification.userInfo[@"post"];
  if ([newPost.isMilestone isEqualToString:@"1"]) {
    [self.results insertObject:newPost atIndex:0];
  }
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

- (void)updateProfileNotificationReceived :(NSNotification *)notification
{
  //  firstName;
  //  lastName;
  //  avatarURL;
}

- (void)feedUpdatedNotificationReceived :(NSNotification *)notification//liked, unliked, commented
{
  LCFeed *newfeed = [notification.userInfo objectForKey:@"post"];
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCFeed class]]) {
      LCFeed *feed = self.results[i];
      if ([feed.entityID isEqualToString:newfeed.entityID])
      {
        if ([newfeed.isMilestone isEqualToString:@"1"]) {
          [self.results replaceObjectAtIndex:i withObject:newfeed];
        }
        break;
      }
    }
  }
  [self refreshViews];
}

- (void)feedEditedNotificationReceived :(NSNotification *)notification
{
  if (!self.isSelfProfile) {
    return;
  }
  LCFeed *newfeed = [notification.userInfo objectForKey:@"post"];
  BOOL isNewMilestone = NO;
  if ([newfeed.isMilestone isEqualToString:@"1"]) {
    isNewMilestone = YES;
  }
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCFeed class]]) {
      LCFeed *feed = self.results[i];
      if ([feed.entityID isEqualToString:newfeed.entityID])
      {
        if ([newfeed.isMilestone isEqualToString:@"1"]) {
          [self.results replaceObjectAtIndex:i withObject:newfeed];
        }
        else
        {
          [self.results removeObjectAtIndex:i];
        }
        isNewMilestone = NO;
        break;
      }
    }
  }
  if (isNewMilestone) {
    [self.results insertObject:newfeed atIndex:0];
  }
  [self refreshViews];
}

- (void)milestoneRemovedNotificationReceived :(NSNotification *)notification
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

- (void)refreshViews
{
//  if ([self.navigationController.topViewController isEqual:self]) {
  
    CGPoint offset = self.tableView.contentOffset;
    [self reloadMilestonesTable];
    [self.tableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self.tableView setContentOffset:offset];
    [self setNoResultViewHidden:[self.results count] != 0];
//  }
}

- (void)setNoResultViewHidden:(BOOL)hidded
{
  if (hidded) {
    [self hideNoResultsView];
  }
  else
  {
    [self showNoResultsView];
  }
}

- (void)reloadMilestonesTable
{
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [self.tableView setContentSize:CGSizeMake(self.tableView.contentSize.width, 0)];
    [self.tableView reloadData];
//    [self.tableView layoutIfNeeded];
//    self.tableContentHeight = self.tableView.contentSize.height+[LCUtilityManager getHeightOffsetForGIB];
//      self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableContentHeight);
    
//  });
}


- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshViews];
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
