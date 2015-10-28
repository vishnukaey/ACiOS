//
//  LCImapactsViewController.m
//  LegacyConnect
//
//  Created by Jijo on 8/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCImapactsViewController.h"
#import "LCFeedCellView.h"
#import "LCFullScreenImageVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import "LCFeedsCommentsController.h"

@implementation LCImapactsViewController
@synthesize customNavigationHeight, userDetail;

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [LCAPIManager getImpactsForUser:userDetail.userID andLastMilestoneID:nil with:^(NSArray *response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCAPIManager getImpactsForUser:userDetail.userID andLastMilestoneID:[(LCFeed*)[self.results lastObject] feedId] with:^(NSArray *response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
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

- (void)addPullToRefresh
{
  [self.tableView .pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
  __weak typeof(self) weakSelf = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [weakSelf startFetchingResults];
    });
  } withBackgroundColor:[UIColor lightGrayColor]];
}

- (void)showFeedCommentsWithFeed:(LCFeed*)feed
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                bundle:nil];
  LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
  [next setFeedObject:feed];
  [self.navigationController pushViewController:next animated:YES];
}

- (void)showFullScreenImage:(LCFeed*)feed
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:YES];
  [appdel.menuButton setHidden:YES];
  LCFullScreenImageVC *vc = [[LCFullScreenImageVC alloc] init];
  vc.feed = feed;
  __weak typeof (self) weakSelf = self;
  vc.commentAction = ^ (id sender, BOOL showComments) {
    [weakSelf fullScreenAction:sender andShowComments:showComments];
  };
  vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)fullScreenAction:(id)sender andShowComments:(BOOL)show
{
  LCFullScreenImageVC * viewController = (LCFullScreenImageVC*)sender;
  [viewController dismissViewControllerAnimated:!show completion:^{
    if (show) {
      [self showFeedCommentsWithFeed:viewController.feed];
    } else {
      [self.tableView reloadData];
    }
  }];
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  self.customNavigationHeight.constant = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  [self addPullToRefresh];
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [self startFetchingResults];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [appdel.menuButton setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - button actions
- (IBAction)backButtonAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource implementation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  JTTABLEVIEW_cellForRowAtIndexPath

//    NSString *nativeUserId = [LCDataManager sharedDataManager].userID;
//    if ([nativeUserId isEqualToString:userDetail.userID])//self profile
//    {
//      return [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"no_impacts_available_self", nil)];
//    }
//    else
//    {
//      return [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"no_impacts_available_others", nil)];
//    }
  
  
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
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

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  switch (type) {
    case kFeedCellActionComment:
      [self showFeedCommentsWithFeed:feed];
      break;
      
      case kFeedCellActionLike:
      //    [self postMessage];
      break;
      
      case kkFeedCellActionViewImage:
      [self showFullScreenImage:feed];
      break;
      
    default:
      break;
  }
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  NSLog(@"tag details-->>%@", tagDetails);
}

@end
