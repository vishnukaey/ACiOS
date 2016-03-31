//
//  LCSearchUsersViewController.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSearchUsersViewController.h"
#import "LCProfileViewVC.h"
#import "LCUserTableViewCell.h"

@interface LCSearchUsersViewController ()

@end

@implementation LCSearchUsersViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

 -(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCSearchAPIManager searchUserUsingsearchKey:_searchKey lastUserId:[(LCUserDetail*)[self.results lastObject] userID] withSuccess:^(id response) {
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self didFailedToFetchResults];
  }];
}

- (void) setUsersArray:(NSArray*) usersArray {
  
  [super startFetchingResults];
  BOOL hasMoreData = [(NSArray*)usersArray count] >= 10;
  [self didFetchResults:usersArray haveMoreData:hasMoreData];
}



#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (!self.results.count && ![[LCUtilityManager performNullCheckAndSetValue:_searchKey] isEqualToString:kEmptyStringValue])
  {
      self.noResultsHereView.hidden = NO;
    }
    else
    {
      self.noResultsHereView.hidden = YES;
    }
    
  return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  header.contentView.backgroundColor = [UIColor whiteColor];
  header.textLabel.font = [UIFont boldSystemFontOfSize:14];
  header.textLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
  CGRect headerFrame = header.frame;
  header.textLabel.frame = headerFrame;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  JTTABLEVIEW_cellForRowAtIndexPath
  LCUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserTableViewCell"];
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  LCUserDetail *user = self.results[indexPath.row];
  cell.user = user;
  return cell;
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UIStoryboard*  profileSB = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
  LCProfileViewVC *profileVC = [profileSB instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
  profileVC.userDetail = [[LCUserDetail alloc] init];
  profileVC.userDetail = self.results[indexPath.row];
  [self.navigationController pushViewController:profileVC animated:YES];
}

@end
