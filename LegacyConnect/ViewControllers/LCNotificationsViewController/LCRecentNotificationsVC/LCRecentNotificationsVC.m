//
//  LCRecentNotificationsVC.m
//  LegacyConnect
//
//  Created by Kaey on 19/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCRecentNotificationsVC.h"
#import "LCRecentNotificationTVC.h"

@interface LCRecentNotificationsVC ()

@end

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
    hasMoreData ? [self hideNoResultsView] : [self showNoResultsView];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self didFailedToFetchResults];
    [self showNoResultsView];
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
  self.tableView.estimatedRowHeight = 44.0f;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"no_feeds_available", nil) andViewWidth:CGRectGetWidth(self.tableView.frame)];
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

#pragma mark - UITableViewDelegate implementation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath

  LCRecentNotificationTVC *cell = [tableView dequeueReusableCellWithIdentifier:[LCRecentNotificationTVC getCellIdentifier]];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCRecentNotificationTVC" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  [cell setNotification:self.results[indexPath.row]];
  return cell;

}

@end
