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
  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void) startFetchingResults
{
  [super startFetchingResults];
  [LCAPIManager getRequestNotificationsWithLastUserId:nil withSuccess:^(NSArray *responses) {
    BOOL hasMoreData = ([(NSArray*)responses count] < 10) ? NO : YES;
    [self didFetchResults:responses haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCAPIManager getRequestNotificationsWithLastUserId:[(LCRequest*)[self.results lastObject] requestID] withSuccess:^(NSArray *responses) {
    BOOL hasMoreData = ([(NSArray*)responses count] < 10) ? NO : YES;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (void) setUsersArray:(NSArray*) usersArray
{
  [super startFetchingResults];
  BOOL hasMoreData = ([(NSArray*)usersArray count] < 10) ? NO : YES;
  [self didFetchResults:usersArray haveMoreData:hasMoreData];
}



#pragma mark - TableView delegates


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 110.0;
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
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
    LCViewActions *actions = [sb instantiateViewControllerWithIdentifier:@"LCViewActions"];
    actions.eventObject = event;
    [self.navigationController pushViewController:actions animated:YES];
  }
  else
  {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *vc = [sb instantiateInitialViewController];
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
  NSIndexPath *index;
  int i = 0;
  for(LCRequest *req in self.results)
  {
    if([req.requestID isEqualToString:request.requestID])
    {
      index = [NSIndexPath indexPathForRow:i inSection:0];
    }
    i++;
  }
  [self.tableView beginUpdates];
  [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationLeft];
  [self.results removeObject:request];
  [self.tableView endUpdates];
}



@end
