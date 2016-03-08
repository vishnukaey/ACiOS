//
//  LCCauseSupportersVC.m
//  LegacyConnect
//
//  Created by Kaey on 12/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCCauseSupportersVC.h"
#import "LCUserTableViewCell.h"
#import "LCProfileViewVC.h"


@interface LCCauseSupportersVC ()

@end

@implementation LCCauseSupportersVC

//

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [self initialSetUp];
  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void) startFetchingResults
{
  [super startFetchingResults];
  int page = (int)self.results.count/kPaginationFactor+1;

  [LCThemeAPIManager getCauseFollowersOfCause:_cause.causeID pageNumber:[NSString stringWithFormat:@"%d",page] andLastID:nil withSuccess:^(NSArray *responses) {
    
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    BOOL hasMoreData = [(NSArray*)responses count] >= kPaginationFactor;
    [self didFetchResults:responses haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self didFailedToFetchResults];
    
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  int page;
  if(self.results.count%kPaginationFactor == 0)
  {
    page = (int)self.results.count/kPaginationFactor+1;
  }
  else
  {
    page= (int)self.results.count/kPaginationFactor+2;
  }
  [LCThemeAPIManager getCauseFollowersOfCause:_cause.causeID pageNumber:[NSString stringWithFormat:@"%d",page] andLastID:[(LCUserDetail*)[self.results lastObject] userID] withSuccess:^(NSArray *responses) {
    BOOL hasMoreData = [(NSArray*)responses count] >= kPaginationFactor;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
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

- (void) setUsersArray:(NSArray*) usersArray
{
  [super startFetchingResults];
  BOOL hasMoreData = [(NSArray*)usersArray count] >= kPaginationFactor;
  [self didFetchResults:usersArray haveMoreData:hasMoreData];
}

#pragma mark - private method implementation
- (void)initialSetUp
{
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.noResultsView = [LCPaginationHelper getNoResultViewWithText:NSLocalizedString(@"members_empty", nil)];
  self.nextPageLoaderCell = [LCPaginationHelper getNextPageLoaderCell];
  
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


//

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
}

//

#pragma mark - TableView delegates

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
  LCUserDetail *user = self.results[indexPath.row];
  LCUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserTableViewCell"];
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  cell.user = user;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIStoryboard*  profileSB = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
  LCProfileViewVC *profileVC = [profileSB instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
  profileVC.userDetail = [self.results objectAtIndex:indexPath.row];
  [self.navigationController pushViewController:profileVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80.0;
}


#pragma mark - IBActions


-(IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
@end
