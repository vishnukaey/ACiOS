//
//  LCAllInterestVC.m
//  LegacyConnect
//
//  Created by qbuser on 12/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCAllInterestVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import "LCInterestsCellView.h"
#import "LCSingleInterestVC.h"

@implementation LCAllInterestVC

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [super startFetchingResults];
  [LCThemeAPIManager getAllInterestsWithLastId:nil success:^(NSArray *response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self stopRefreshingViews];
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
    [self didFetchResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCThemeAPIManager getAllInterestsWithLastId:[(LCInterest*)[self.results lastObject] interestID] success:^(NSArray *response) {
    [self stopRefreshingViews];
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
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

- (void)setNoResultViewHidden:(BOOL)hide
{
  if (hide) {
    [self hideNoResultsView];
  }
  else
  {
    [self showNoResultsView];
  }
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialSetUp];
}

#pragma maek - private method inplementation
- (void)initialSetUp
{
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"no_interests_available_others", nil)];
  self.nextPageLoaderCell = [LCUtilityManager getNextPageLoaderCell];
  
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

- (void)loadAllIntrests
{
  [self startFetchingResults];
  [self setNoResultViewHidden:(self.results.count > 0)];
}

#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  [self setNoResultViewHidden:(self.results.count > 0)];
  return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath
  static NSString *MyIdentifier = @"LCInterestsCell";
  LCInterestsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCInterestsCellView" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  LCInterest *interstObj = [self.results objectAtIndex:indexPath.row];
  [cell setData:interstObj];
  cell.checkButtonWidth.constant = 0;
  cell.checkButtonTrailing.constant = 0;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCInterest *interest = [self.results objectAtIndex:indexPath.row];
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
  LCSingleInterestVC *interestVC = [storyboard instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
  interestVC.interest = interest;
  [self.navigationController pushViewController:interestVC animated:YES];
}



@end
