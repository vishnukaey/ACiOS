//
//  LCRecentNotificationsVC.m
//  LegacyConnect
//
//  Created by Kaey on 19/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCRecentNotificationsVC.h"
#import "LCRecentNotificationTVC.h"
#import "LCFeedsCommentsController.h"
#import "LCViewActions.h"
#import "LCProfileViewVC.h"

@implementation LCRecentNotificationsVC

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [LCAPIManager getRecentNotificationsWithLastId:nil withSuccess:^(id response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCAPIManager getRecentNotificationsWithLastId:[(LCRecentNotification*)[self.results lastObject] notificationId] withSuccess:^(id response) {
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (void)stopRefreshingViews
{
  //-- Stop Refreshing Views -- //
  if (self.tableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
    [self.tableView.pullToRefreshView stopAnimating];
  }
}

#pragma mark - private method implementation
- (void)initialSetUp
{
  self.tableView.estimatedRowHeight = 88.0f;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"no_recent_notifications_available", nil) andViewWidth:CGRectGetWidth(self.tableView.frame)];
  self.nextPageLoaderCell = [LCUtilityManager getNextPageLoaderCell];
  
  // Pull to Refresh Interface to Feeds TableView.
  __weak typeof(self) weakSelf = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    [weakSelf hideNoResultsView];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [weakSelf startFetchingResults];
    });
  } withBackgroundColor:[UIColor lightGrayColor]];
}

#pragma mark - view life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [self initialSetUp];
  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
  [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (self.results.count > 0) {
    [self hideNoResultsView];
  } else {
    [self showNoResultsView];
  }
  return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath

  LCRecentNotificationTVC *cell = [tableView dequeueReusableCellWithIdentifier:[LCRecentNotificationTVC getCellIdentifier]];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCRecentNotificationTVC" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  [cell setNotification:self.results[indexPath.row]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCRecentNotification * notification = self.results[indexPath.row];
  if ([notification.entityType isEqualToString:kEntityTypePost]) {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    LCFeedsCommentsController *commentsVC = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
    commentsVC.feedId = notification.entityId;
    [self.navigationController pushViewController:commentsVC animated:YES];
  } else if ([notification.entityType isEqualToString:kEntityTypeEvent]) {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
    LCViewActions *actions = [sb instantiateViewControllerWithIdentifier:@"LCViewActions"];
    LCEvent * event = [[LCEvent alloc] init];
    event.eventID = notification.entityId;
    actions.eventObject = event;
    [self.navigationController pushViewController:actions animated:YES];
  } else if ([notification.entityType isEqualToString:kEntityTypeUserProfile]) {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = notification.entityId;
    [self.navigationController pushViewController:vc animated:YES];
  }
  [self markNotificationAsRead:notification];
}

- (void)markNotificationAsRead:(LCRecentNotification*)notification
{
  if (!notification.isRead) {
    [LCAPIManager markNotificationAsRead:notification.notificationId andStatus:^(BOOL status) {
      notification.isRead = YES;
    }];
  }
}

@end
