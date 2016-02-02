//
//  LCInterestsVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCInterestsVC.h"
#import "LCInterestsCellView.h"
#import "LCViewActions.h"
#import "LCSingleInterestVC.h"

@implementation LCInterestsVC

#pragma mark - API call and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCUserProfileAPIManager getInterestsForUser:self.userID lastId:nil withSuccess:^(NSArray *responses) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    BOOL hasMoreData = responses.count >= 20;
    [self didFetchResults:responses haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCUserProfileAPIManager getInterestsForUser:self.userID lastId:[(LCInterest*)[self.results lastObject] interestID] withSuccess:^(NSArray *responses) {
    BOOL hasMoreData = responses.count >= 20;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}


#pragma mark - view life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initailSetup];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - private method implementation
- (void) initailSetup
{
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tableView.allowsSelection = YES;
  isSelfProfile = [self.userID isEqualToString:[LCDataManager sharedDataManager].userID];
  if (!self.noResultsView) {
    NSString *message = NSLocalizedString(@"no_interests_available_others", nil);
    if (isSelfProfile) {
      message = NSLocalizedString(@"no_interests_available_self", nil);
    }
    self.noResultsView = [LCPaginationHelper getNoResultViewWithText:message];
  }
  self.nextPageLoaderCell = [LCPaginationHelper getNextPageLoaderCell];
}

- (void)loadInterests
{
  [self startFetchingResults];
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
    cell = topLevelObjects[0];
  }
  LCInterest *interstObj = [self.results objectAtIndex:indexPath.row];
  [cell setData:interstObj];
  cell.checkButtonWidth.constant = 0;
  cell.checkButtonTrailing.constant = 0;
  return cell;
}

#pragma mark - ScrollView delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.delegate scrollViewScrolled:scrollView];
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
