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
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self didFailedToFetchResults];
  }];
}

- (void) setUsersArray:(NSArray*) usersArray {
  
  [super startFetchingResults];
  BOOL hasMoreData = ([(NSArray*)usersArray count] < 10) ? NO : YES;
  [self didFetchResults:usersArray haveMoreData:hasMoreData];
}

- (UIView *)getNOResultLabel
{
  UILabel * noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  [noResultLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [noResultLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  noResultLabel.textAlignment = NSTextAlignmentCenter;
  noResultLabel.numberOfLines = 2;
  [noResultLabel setText:@"No Results Found"];
  return noResultLabel;
}

#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  UIView *prev = [tableView viewWithTag:122];
  if (prev)
  {
    [prev removeFromSuperview];
  }
  if (!self.results.count) {
    UIView *noResultView = [self getNOResultLabel];
    noResultView.tag = 122;
    noResultView.center = CGPointMake(tableView.frame.size.width/2, noResultView.center.y);
    [tableView addSubview:noResultView];
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
  
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
  LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
  vc.userDetail = [[LCUserDetail alloc] init];
  vc.userDetail = self.results[indexPath.row];
  [self.navigationController pushViewController:vc animated:YES];
  
}

@end
