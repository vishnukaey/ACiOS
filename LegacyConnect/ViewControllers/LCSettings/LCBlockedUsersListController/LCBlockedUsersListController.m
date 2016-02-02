//
//  LCBlockedUsersListController.m
//  LegacyConnect
//
//  Created by qbuser on 30/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCBlockedUsersListController.h"
#import "LCBlockedUsersCell.h"

@interface LCBlockedUsersListController ()

@end

@implementation LCBlockedUsersListController

#pragma mark - view life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
  footerView.backgroundColor = self.tableView.separatorColor;
  self.tableView.tableFooterView = footerView;
  self.noResultsView = [LCPaginationHelper getNoResultViewWithText:NSLocalizedString(@"no_blocked_users", nil)];
  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma maek - Button Actions
- (IBAction)cancelButtonTapped:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(id)sender
{
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath
  LCBlockedUsersCell * friendsCell = (LCBlockedUsersCell*)[tableView dequeueReusableCellWithIdentifier:@"LCBlockedUsersCell" forIndexPath:indexPath];
  if (friendsCell == nil) {
    friendsCell = [[LCBlockedUsersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LCBlockedUsersCell"];
  }
  friendsCell.userDetails = [self.results objectAtIndex:indexPath.row];
  return friendsCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 88.0f;
}


#pragma maek - private method implementation
- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCSettingsAPIManager getBlockedUsersWithSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self didFetchResults:response haveMoreData:NO];
    [self noresultViewUpdate];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self didFailedToFetchResults];
    [self noresultViewUpdate];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
}

- (void)noresultViewUpdate
{
  if (self.results.count > 0) {
    [self hideNoResultsView];
  } else {
    [self showNoResultsView];
  }
}



@end
