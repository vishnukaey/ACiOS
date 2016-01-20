//
//  LCEventMembersViewController.m
//  LegacyConnect
//
//  Created by Kaey on 09/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCEventMembersViewController.h"
#import "LCUserTableViewCell.h"
#import "LCProfileViewVC.h"
#import "LCInviteToActions.h"
#import "LCEventAPImanager.h"

@interface LCEventMembersViewController ()
@end

@implementation LCEventMembersViewController


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
  [LCEventAPImanager getMembersForEventID:_event.eventID andLastEventID:nil withSuccess:^(NSArray *responses) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    BOOL hasMoreData = ([(NSArray*)responses count] < 10) ? NO : YES;
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
  
  [LCEventAPImanager getMembersForEventID:_event.eventID andLastEventID:[(LCUserDetail*)[self.results lastObject] userID] withSuccess:^(NSArray *responses) {
    BOOL hasMoreData = ([(NSArray*)responses count] < 10) ? NO : YES;
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
  BOOL hasMoreData = ([(NSArray*)usersArray count] < 10) ? NO : YES;
  [self didFetchResults:usersArray haveMoreData:hasMoreData];
}

#pragma mark - private method implementation
- (void)initialSetUp
{
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"members_empty", nil)];
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


//

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if(_event.isFollowing)
  {
    _inviteViewHeight.constant = 44.0;
  }
  else
  {
   _inviteViewHeight.constant = 0.0;
  }
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

-(IBAction)inviteFriends:(id)sender
{
  UIStoryboard*  actionsSB = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
  LCInviteToActions *actionsVC = [actionsSB instantiateViewControllerWithIdentifier:@"LCInviteToActions"];
  actionsVC.eventToInvite = self.event;
  [self presentViewController:actionsVC animated:YES completion:nil];
}


-(IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
@end
