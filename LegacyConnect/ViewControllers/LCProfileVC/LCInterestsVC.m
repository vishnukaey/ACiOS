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

@interface LCInterestsVC ()

@end

@implementation LCInterestsVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self initailSetup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private method implementation

- (void) initailSetup {
  
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  isSelfProfile = [self.userID isEqualToString:[LCDataManager sharedDataManager].userID];
  
  if (!self.noResultsView) {
    NSString *message = NSLocalizedString(@"no_interests_available_others", nil);
    if (isSelfProfile) {
      message = NSLocalizedString(@"no_interests_available_self", nil);
    }
    self.noResultsView = [LCUtilityManager getNoResultViewWithText:message andViewWidth:CGRectGetWidth(self.tableView.frame)];
  }

}

- (void)loadInterests
{
  [self startFetchingResults];
}

#pragma mark - API call and Pagination

- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [LCAPIManager getInterestsForUser:self.userID withSuccess:^(NSArray *responses) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = NO;
    [self didFetchResults:responses haveMoreData:hasMoreData];
    [self setNoResultViewHidden:[self.results count] != 0];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self didFailedToFetchResults];
    [self setNoResultViewHidden:[self.results count] != 0];
  }];
}

- (void)startFetchingNextResults
{
  //Currently no pagination required for interests
      //  [super startFetchingNextResults];
      //  [LCAPIManager getInterestsForUser:self.userID withSuccess:^(NSArray *responses) {
      //    [self stopRefreshingViews];
      //    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
      //    [self didFetchNextResults:response haveMoreData:hasMoreData];
      //  } andFailure:^(NSString *error) {
      //    [self stopRefreshingViews];
      //    [self didFailedToFetchResults];
      //  }];
}

- (void)setNoResultViewHidden:(BOOL)hidded
{
  if (hidded) {
    [self hideNoResultsView];
  }
  else
  {
    [self showNoResultsView];
  }
}

#pragma mark - TableView delegates

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
  
  tableView.backgroundColor = [UIColor clearColor];
  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  tableView.allowsSelection = YES;
  
  return cell;
}

#pragma mark - ScrollView delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.delegate scrollViewScrolled:scrollView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
