//
//  LCFeedsHomeViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsHomeViewController.h"
#import "LCLoginHomeViewController.h"
#import "LCFullScreenImageVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "LCSingleCauseVC.h"
#import "LCProfileViewVC.h"
#import "LCSearchViewController.h"
#import "LCLoadingCell.h"
#import "LCSocialShareManager.h"

static CGFloat kFeedCellRowHeight = 44.0f;
static CGFloat kNumberOfSectionsInFeeds = 1;
static NSString *kFeedCellXibName = @"LCFeedcellXIB";

@implementation LCFeedsHomeViewController


- (void)logId:(NSArray*)array
{
  NSLog(@"------------------");
  for (LCFeed * feed in array) {
    NSLog(@"id > %@",feed.feedId);
  }
}

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [LCAPIManager getHomeFeedsWithLastFeedId:nil success:^(NSArray *response) {
    [self logId:response];
    [self stopRefreshingViews];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCAPIManager getHomeFeedsWithLastFeedId:[(LCFeed*)[self.results lastObject] feedId] success:^(NSArray *response) {
    [self logId:response];
    [self stopRefreshingViews];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
}

#pragma mark - private method implementation
- (void)stopRefreshingViews
{
  //-- Stop Refreshing Views -- //
  if (self.tableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
    [self.tableView.pullToRefreshView stopAnimating];
  }
}

- (void)initialUISetUp
{
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  self.customNavigationHeight.constant = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.estimatedRowHeight = kFeedCellRowHeight;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  // Pull to Refresh Interface to Feeds TableView.
  __weak typeof(self) weakSelf = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [weakSelf startFetchingResults];
    });
  } withBackgroundColor:[UIColor lightGrayColor]];
}

- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  switch (type) {
      
    case kFeedCellActionComment:
      [self showFeedCommentsWithFeed:feed];
      break;
      
    case kFeedCellActionLike:
      /**
       * Like/Unlike actions will be handled from 'LCFeedCellView' class.
       */
      break;
      
    case kkFeedCellActionViewImage:
      [self showFullScreenImage:feed];
      break;
      
    default:
      break;
  }
}

- (void)showFeedCommentsWithFeed:(LCFeed*)feed
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                bundle:nil];
  LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
  [next setFeedObject:feed];
  [self.navigationController pushViewController:next animated:YES];
}

- (void)showFullScreenImage:(LCFeed*)feed
{
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:YES MenuVisibilityStatus:YES];
  LCFullScreenImageVC *vc = [[LCFullScreenImageVC alloc] init];
  vc.feed = feed;
  __weak typeof (self) weakSelf = self;
  vc.commentAction = ^ (id sender, BOOL showComments) {
    [weakSelf fullScreenAction:sender andShowComments:showComments];
  };
  vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)fullScreenAction:(id)sender andShowComments:(BOOL)show
{
  LCFullScreenImageVC * viewController = (LCFullScreenImageVC*)sender;
  [viewController dismissViewControllerAnimated:!show completion:^{
    if (show) {
      [self showFeedCommentsWithFeed:viewController.feed];
    } else {
      [self.tableView reloadData];
    }
  }];
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  LCDLog(@"tag details-->>%@", tagDetails);
  if ([tagDetails[@"type"] isEqualToString:kFeedTagTypeCause])//go to cause page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    [self.navigationController pushViewController:vc animated:YES];
  }
  else if ([tagDetails[@"type"] isEqualToString:kFeedTagTypeUser])//go to user page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  [self startFetchingResults];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:NO MenuVisibilityStatus:NO];
  [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:YES MenuVisibilityStatus:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return kNumberOfSectionsInFeeds;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  JTTABLEVIEW_cellForRowAtIndexPath
  
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:kFeedCellXibName owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  [cell setData:[self.results objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
  __weak typeof(self) weakSelf = self;
  cell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
    [weakSelf feedCellActionWithType:actionType andFeed:feed];
  };
  cell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
    [weakSelf tagTapped:tagDetails];
  };
  return cell;
}

#pragma mark - Button Actions
-(IBAction)search:(id)sender
{
  LCSearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCSearchViewController"];
  [self.navigationController pushViewController:searchVC animated:NO];
}

@end
