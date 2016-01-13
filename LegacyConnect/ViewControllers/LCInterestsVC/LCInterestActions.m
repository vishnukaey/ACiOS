//
//  LCInterestActions.m
//  LegacyConnect
//
//  Created by Akhil K C on 1/4/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCInterestActions.h"
#import "LCActionsCellView.h"
#import "LCViewActions.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>

@interface LCInterestActions ()

@end

@implementation LCInterestActions

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self initailSetup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - API call and Pagination

- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCEventAPImanager getListOfEventsForInterestID:self.interest.interestID lastID:nil withSuccess:^(NSArray *response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchResults:response haveMoreData:hasMoreData];
    [self setNoResultViewHidden:[(NSArray*)response count] != 0];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self didFailedToFetchResults];
    [self setNoResultViewHidden:[self.results count] != 0];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCEventAPImanager getListOfEventsForInterestID:self.interest.interestID lastID:[(LCEvent*)[self.results lastObject] eventID] withSuccess:^(NSArray *response) {
    [self stopRefreshingViews];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
}

#pragma mark - private method implementation

- (void) initailSetup {
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  NSString *message = NSLocalizedString(@"no_actions_to_display", nil);
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:message andViewWidth:CGRectGetWidth(self.tableView.frame)];

  self.nextPageLoaderCell = [LCUtilityManager getNextPageLoaderCell];
  [self addPullToRefreshForActionsTable];
}

- (void)stopRefreshingViews
{
  //-- Stop Refreshing Views -- //
  if (self.tableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
    [self.tableView.pullToRefreshView stopAnimating];
  }
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

- (void)addPullToRefreshForActionsTable
{
  [self.tableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
  __weak typeof (self) weakSelf = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    [weakSelf setNoResultViewHidden:YES];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [weakSelf startFetchingResults];
    });
  }withBackgroundColor:[UIColor lightGrayColor]];
}

- (void)loadActionsInCurrentInterest
{
  [self startFetchingResults];
}

- (IBAction)backAction:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  [self setNoResultViewHidden:self.results.count > 0];
  return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath
  static NSString *MyIdentifier = @"LCActionsCell";
  LCActionsCellView *cell = (LCActionsCellView*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCActionsCellView" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  [cell setEvent:[self.results objectAtIndex:indexPath.row]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
  LCViewActions *actions = [sb instantiateViewControllerWithIdentifier:@"LCViewActions"];
  actions.eventObject = self.results[indexPath.row];
  //UIViewController *profileController = (UIViewController *)self.delegate;
  [self.navigationController pushViewController:actions animated:YES];
}

#pragma mark - ScrollView delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.delegate scrollViewScrolled:scrollView];
}

@end
