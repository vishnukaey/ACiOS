//
//  LCInterestPostsThanked.m
//  LegacyConnect
//
//  Created by Jijo on 3/22/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCInterestPostsThanked.h"
#import "LCFeedCellView.h"
#import "LCFeedsCommentsController.h"
#import "LCFullScreenImageVC.h"
#import "LCProfileViewVC.h"
#import "LCSingleInterestVC.h"
#import "LCSingleCauseVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import "LCReportHelper.h"

@interface LCInterestPostsThanked ()

@end

@implementation LCInterestPostsThanked

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self initialSetUp];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  UIViewController * parentController = self.parentViewController;
  if (parentController != nil && [parentController isKindOfClass:[UINavigationController class]])
  {
    [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
  }
}

#pragma mark - private method implementation

- (void)initialSetUp
{
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  NSString *message = NSLocalizedString(@"no_posts_to_display", nil);
  self.noResultsView = [LCPaginationHelper getNoResultViewWithText:message];
  
  [self addPullToRefreshForPostsTable];
}

- (void)addPullToRefreshForPostsTable
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

- (void)stopRefreshingViews
{
  //-- Stop Refreshing Views -- //
  if (self.tableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
    [self.tableView.pullToRefreshView stopAnimating];
  }
}

- (void) loadPostsInCurrentInterest {
  [self startFetchingResults];
}

#pragma mark - API and Pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [super startFetchingResults];
  [LCThemeAPIManager getPostsInInterestByThankedOrder:self.interest.interestID andLastPostID:nil andPageNumber:[NSString stringWithFormat:@"%lu", self.results.count/10 + 1] withSuccess:^(NSArray *response) {
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
    [self didFetchResults:response haveMoreData:hasMoreData];
    [self setNoResultViewHidden:[(NSArray*)response count] != 0];
    [self reloadPostsTable];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
    [self setNoResultViewHidden:[self.results count] != 0];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCThemeAPIManager getPostsInInterestByThankedOrder:self.interest.interestID andLastPostID:nil andPageNumber:[NSString stringWithFormat:@"%lu", self.results.count/10 + 1] withSuccess:^(NSArray *response) {
    [self stopRefreshingViews];
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
    [self reloadPostsTable];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
}

- (IBAction)backAction:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return self.results.count;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  JTTABLEVIEW_cellForRowAtIndexPath
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = topLevelObjects[0];
  }
  [cell setData:[self.results objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
  __weak typeof(self) weakSelf = self;
  cell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
    [weakSelf feedCellActionWithType:actionType andFeed:feed];
  };
  cell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
    [weakSelf tagTapped:tagDetails];
  };
  
  tableView.backgroundColor = [UIColor clearColor];
  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  tableView.allowsSelection = YES;
  
  return cell;
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  
  if (type == kkFeedCellActionViewImage)
  {
    [self showFullScreenImage:feed];
  }
  else if (type == kFeedCellActionComment)
  {
    [self showFeedCommentsWithFeed:feed];
  }
  else if (type == kkFeedCellActionReport)
  {
    [self reportFeed:feed];
  }
}

- (void)showFeedCommentsWithFeed:(LCFeed*)feed
{
  UIStoryboard *storyboard = [UIStoryboard  storyboardWithName:kMainStoryBoardIdentifier
                                                        bundle:nil];
  LCFeedsCommentsController *next = [storyboard instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
  [next setFeedObject:feed];
  [self.navigationController pushViewController:next animated:YES];
}

- (void)showFullScreenImage:(LCFeed*)feed
{
  LCFullScreenImageVC *fullScreenImageView = [[LCFullScreenImageVC alloc] init];
  fullScreenImageView.feed = feed;
  __weak typeof (self) weakSelf = self;
  fullScreenImageView.commentAction = ^ (id sender, BOOL showComments) {
    [weakSelf fullScreenAction:sender andShowComments:showComments];
  };
  fullScreenImageView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:fullScreenImageView animated:YES completion:nil];
}

- (void)fullScreenAction:(id)sender andShowComments:(BOOL)show
{
  LCFullScreenImageVC * viewController = (LCFullScreenImageVC*)sender;
  [viewController dismissViewControllerAnimated:!show completion:^{
    if (show) {
      [self showFeedCommentsWithFeed:viewController.feed];
    } else {
      [self reloadPostsTable];
    }
  }];
}

- (void)reportFeed:(LCFeed*)feed
{
  [LCReportHelper showPostReportActionSheetFromView:self withPost:feed];
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeCause])//go to cause page
  {
    UIStoryboard *  interestSB = [UIStoryboard  storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
    LCSingleCauseVC *causeVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    causeVC.cause.interestID = tagDetails[kTagobjId];
    [self.navigationController pushViewController:causeVC animated:YES];
  }
  else if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeUser])//go to user page
  {
    UIStoryboard *  profileSB = [UIStoryboard  storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *profileVC = [profileSB instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    profileVC.userDetail = [[LCUserDetail alloc] init];
    profileVC.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:profileVC animated:YES];
  }
  //  else if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeInterest])//go to interest page
  //  {
  //    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
  //    LCSingleInterestVC *interestVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
  //    interestVC.interest = [[LCInterest alloc] init];
  //    interestVC.interest.interestID = tagDetails[kTagobjId];
  //    [self.navigationController pushViewController:interestVC animated:YES];
  //  }
}

@end
