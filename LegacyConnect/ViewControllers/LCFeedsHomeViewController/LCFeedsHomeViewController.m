//
//  LCFeedsHomeViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsHomeViewController.h"
#import "LCLoginHomeViewController.h"
#import "LCFullScreenImageVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "LCSingleCauseVC.h"
#import "LCSingleInterestVC.h"
#import "LCProfileViewVC.h"
#import "LCSearchViewController.h"
#import "LCLoadingCell.h"
#import "LCSocialShareManager.h"

static CGFloat kFeedCellRowHeight = 44.0f;
static NSString *kFeedCellXibName = @"LCFeedcellXIB";

@implementation LCFeedsHomeViewController

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [LCFeedAPIManager getHomeFeedsWithLastFeedId:nil success:^(NSArray *response) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
    [self didFetchResults:response haveMoreData:hasMoreData];
    [self setNoResultViewHidden:[(NSArray*)response count] != 0];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
    [self setNoResultViewHidden:[self.results count] != 0];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCFeedAPIManager getHomeFeedsWithLastFeedId:[(LCFeed*)[self.results lastObject] feedId] success:^(NSArray *response) {
    [self stopRefreshingViews];
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
}


#pragma mark - private method implementation
- (void)stopRefreshingViews
{
  //-- Stop Refreshing Views -- //
  if (self.tableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
    [self.tableView.pullToRefreshView stopAnimating];
  }
}

- (void)initialUISetUp
{
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  self.customNavigationHeight.constant = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.estimatedRowHeight = kFeedCellRowHeight;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"no_feeds_available", nil)];
  self.nextPageLoaderCell = [LCUtilityManager getNextPageLoaderCell];
  
  // Pull to Refresh Interface to Feeds TableView.
  __weak typeof(self) weakSelf = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    [weakSelf setNoResultViewHidden:YES];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [weakSelf startFetchingResults];
    });
  } withBackgroundColor:[UIColor lightGrayColor]];
}

- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  switch (type) {
      
    case kFeedCellActionComment:
      [self showFeedCommentsWithFeed:feed];
      break;
      
    case kFeedCellActionLike:
      /**
       * Like/Unlike actions will be handled from 'LCFeedCellView' class.
       */
      break;
      
    case kkFeedCellActionViewImage:
      [self showFullScreenImage:feed];
      break;
      
    default:
      break;
  }
}

- (void)showFeedCommentsWithFeed:(LCFeed*)feed
{
  UIStoryboard*  mainSB = [UIStoryboard storyboardWithName:@"Main"
                                                bundle:nil];
  LCFeedsCommentsController *next = [mainSB instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
  [next setFeedObject:feed];
  [self.navigationController pushViewController:next animated:YES];
}

- (void)showFullScreenImage:(LCFeed*)feed
{
  LCFullScreenImageVC *imageVC = [[LCFullScreenImageVC alloc] init];
  imageVC.feed = feed;
  __weak typeof (self) weakSelf = self;
  imageVC.commentAction = ^ (id sender, BOOL showComments) {
    [weakSelf fullScreenAction:sender andShowComments:showComments];
  };
  imageVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:imageVC animated:YES completion:nil];
}

- (void)fullScreenAction:(id)sender andShowComments:(BOOL)show
{
  LCFullScreenImageVC * viewController = (LCFullScreenImageVC*)sender;
  [viewController dismissViewControllerAnimated:!show completion:^{
    if (show) {
      [self showFeedCommentsWithFeed:viewController.feed];
    }
  }];
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeCause])//go to cause page
  {
    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleCauseVC *causeVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    causeVC.cause = [[LCCause alloc] init];
    causeVC.cause.causeID = tagDetails[kTagobjId];
    [self.navigationController pushViewController:causeVC animated:YES];
  }
  else if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeUser])//go to user page
  {
    UIStoryboard*  profileSB = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *profileVC = [profileSB instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    profileVC.userDetail = [[LCUserDetail alloc] init];
    profileVC.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:profileVC animated:YES];
  }
  else if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeInterest])//go to interest page
  {
    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleInterestVC *interestVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
    interestVC.interest = [[LCInterest alloc] init];
    interestVC.interest.interestID = tagDetails[kTagobjId];
    [self.navigationController pushViewController:interestVC animated:YES];
  }
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [self startFetchingResults];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setLCStatusBarStyle];
  self.navigationController.navigationBarHidden = YES;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
  
  //GATracking
  [LCGAManager ga_trackViewWithName:@"Feeds Home"];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource implementation

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  JTTABLEVIEW_cellForRowAtIndexPath
  
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:kFeedCellXibName owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  [cell setData:[self.results objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
  __weak typeof(self) weakSelf = self;
  cell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
    [weakSelf feedCellActionWithType:actionType andFeed:feed];
  };
  cell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
    [weakSelf tagTapped:tagDetails];
  };
  return cell;
}

#pragma mark - UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  LCFeed * feed = [feedsArray objectAtIndex:indexPath.row];
//  [self showFeedCommentsWithFeed:feed];
}


#pragma mark - Button Actions
-(IBAction)search:(id)sender
{
  LCSearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCSearchViewController"];
  [self.navigationController pushViewController:searchVC animated:NO];
}

@end
