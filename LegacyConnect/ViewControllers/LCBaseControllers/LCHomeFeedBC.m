//
//  LCFeedTableViewController.m
//  LegacyConnect
//
//  Created by Jijo on 11/3/15.
//  Copyright © 2015 Gist. All rights reserved.
//

/* notifications to be handled
 1: liked a post *** handled
 2: unliked post *** handled
 3: commented a post *** handled
 4: Updated a post *** handled
 5: deleted a post *** handled
 6: created new post *** handled
 7: user profile updated - should handle if mandatory, else if server dosent reflect the changes it may cause confusion
 8: remove milestone - if milestone icon is shown in homefeed
 */

#import "LCHomeFeedBC.h"
#import "LCProfileViewVC.h"

@interface LCHomeFeedBC ()

@end

@implementation LCHomeFeedBC

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kLikedPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kUnlikedPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kCommentPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kCommentDeletedPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kUpdatePostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedDeletedNotificationReceived:) name:kDeletePostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPostCreatedNotificationReceived:) name:kCreateNewPostNFK object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedReportedNotificationReceived:) name:kReportedPostNFK object:nil];
  
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileNotificationReceived:) name:kUpdateProfileNFK object:nil];
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
  if ([self.navigationController.topViewController isEqual:self]) {
    CGPoint offset = self.tableView.contentOffset;
//    [self.tableView reloadData];

    [self reloadFeedsTable];
//    [self.tableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
//    [self.tableView setContentOffset:offset];
    [self setNoResultViewHidden:[self.results count] != 0];
  }
}

- (void)reloadFeedsTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
//      CGPoint offset = self.tableView.contentOffset;
//      [self.tableView setContentSize:CGSizeMake(self.tableView.contentSize.width, 0)];
  [self.tableView reloadData];
//      [self.tableView setContentOffset:offset];
  //    [self.tableView layoutIfNeeded];
  //    self.tableContentHeight = self.tableView.contentSize.height+[LCUtilityManager getHeightOffsetForGIB];
  //      self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableContentHeight);
  
    });
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
