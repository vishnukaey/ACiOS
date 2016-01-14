//
//  LCRequestsNotificationsVC.m
//  LegacyConnect
//
//  Created by Kaey on 19/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCRequestsNotificationsVC.h"
#import "LCRequestNotificationTVC.h"
#import "LCProfileViewVC.h"
#import "LCViewActions.h"

@interface LCRequestsNotificationsVC () <LCRequestNotificationTVCDelegate>
@end

@implementation LCRequestsNotificationsVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self initialSetUp];
//  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

-(void) getRequests
{
  [self startFetchingResults];
} 

-(void) startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCNotificationsAPIManager getRequestNotificationsWithLastUserId:nil withSuccess:^(NSArray *responses) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    BOOL hasMoreData = ([(NSArray*)responses count] < 10) ? NO : YES;
    [self didFetchResults:responses haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCNotificationsAPIManager getRequestNotificationsWithLastUserId:[(LCRequest*)[self.results lastObject] requestID] withSuccess:^(NSArray *responses) {
    BOOL hasMoreData = ([(NSArray*)responses count] < 10) ? NO : YES;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
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
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"no_requests_pending", nil)];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath
  LCRequest *request = self.results[indexPath.row];
  LCRequestNotificationTVC *cell;
  if( [[LCUtilityManager performNullCheckAndSetValue:request.type] isEqualToString:@"event"])
  {
    cell =[tableView dequeueReusableCellWithIdentifier:@"LCRequestNotificationTVC"];
  }
  else
  {
    cell = [tableView dequeueReusableCellWithIdentifier:@"LCFriendRequestNotificationTVC"];
  }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.request = request;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCRequest *request = [self.results objectAtIndex:indexPath.row];
  
  if([request.type isEqualToString:@"event"])
  {
    LCEvent *event = [[LCEvent alloc] init];
    event.eventID =request.eventID;
    UIStoryboard * actionsSB = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
    LCViewActions *actions = [actionsSB instantiateViewControllerWithIdentifier:@"LCViewActions"];
    actions.eventObject = event;
    [self.navigationController pushViewController:actions animated:YES];
  }
  else
  {
    UIStoryboard *profileSB = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *vc = [profileSB instantiateInitialViewController];
    vc.userDetail = [[LCUserDetail alloc] init];
    LCRequest *request = [self.results objectAtIndex:indexPath.row];
    vc.userDetail.userID = request.friendID;
    [self.navigationController pushViewController:vc animated:YES];
  }
}

-(void)requestActionedForRequest:(LCRequest *)request
{
  [self.tableView reloadData];
  [self performSelector:@selector(deleteCellForRequest:) withObject:request afterDelay:2.0];
}


-(void) deleteCellForRequest:(LCRequest*)request
{
  NSIndexPath *indexpath;
  int index = 0;
  for(LCRequest *req in self.results)
  {
    if([req.requestID isEqualToString:request.requestID])
    {
      indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    }
    index++;
  }
  [self.tableView beginUpdates];
  [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationLeft];
  [self.results removeObject:request];
  [self.tableView endUpdates];
}



@end
