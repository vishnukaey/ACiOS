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
#import "LCCreatePostViewController.h"
#import "LCProfileViewVC.h"
#import "LCSingleCauseVC.h"
#import "LCSingleInterestVC.h"

@implementation LCImapactsViewController
@synthesize customNavigationHeight, userDetail;

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [LCUserProfileAPIManager getImpactsForUser:userDetail.userID andLastImpactsID:nil with:^(NSArray *response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchResults:response haveMoreData:hasMoreData];
    [self reloadImpactsTable];
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
  [LCUserProfileAPIManager getImpactsForUser:userDetail.userID andLastImpactsID:[(LCFeed*)[self.results lastObject] entityID] with:^(NSArray *response) {
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
    [weakSelf setNoResultViewHidden:YES];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [weakSelf startFetchingResults];
    });
  } withBackgroundColor:[UIColor lightGrayColor]];
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
    } else {
      [self reloadImpactsTable];
    }
  }];
}

- (void)feedCellMoreAction :(LCFeed *)feed
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *editPost = [UIAlertAction actionWithTitle:@"Edit Post" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    UIStoryboard*  story_board = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
    LCCreatePostViewController * createPostVC = [story_board instantiateInitialViewController];
    createPostVC.isEditing = YES;
    createPostVC.postFeedObject = feed;
    createPostVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:createPostVC animated:YES completion:nil];
  }];
  
  [actionSheet addAction:editPost];
  
  
  UIAlertAction *deletePost = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete_post", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"delete_post", nil) message:NSLocalizedString(@"delete_post_message", nil) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *deletePostActionFinal = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                      [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
                      [LCPostAPIManager deletePost:feed withSuccess:^(NSArray *response) {
                        [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                      }
                                    andFailure:^(NSString *error) {
                                      [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                                      NSLog(@"%@",error);
                                    }];
                    }];
                    [deleteAlert addAction:deletePostActionFinal];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
                    [deleteAlert addAction:cancelAction];
                    [self presentViewController:deleteAlert animated:YES completion:nil];
  }];
  [actionSheet addAction:deletePost];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
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
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [LCUtilityManager getHeightOffsetForGIB])];
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"no_impacts_available_others", nil) andViewWidth:CGRectGetWidth(self.tableView.frame)];
  
  [self addPullToRefresh];
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [self startFetchingResults];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  JTTABLEVIEW_cellForRowAtIndexPath
  
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
  //self profile check
  if ([[LCDataManager sharedDataManager].userID isEqualToString:userDetail.userID]) {
    
    cell.moreButton.hidden = NO;
  }

  return cell;
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  switch (type) {
      
    case kkFeedCellActionLoadMore:
      [self feedCellMoreAction :feed];
      break;
      
    case kFeedCellActionComment:
      [self showFeedCommentsWithFeed:feed];
      break;
      
    case kFeedCellActionLike:
      //    [self postMessage];
      break;
      
    case kkFeedCellActionViewImage:
      [self showFullScreenImage:feed];
      break;
  }
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeCause])//go to cause page
  {
    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleCauseVC *causeVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
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
  else if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeInterest])//go to cause page
  {
    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleInterestVC *causeVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
    [self.navigationController pushViewController:causeVC animated:YES];
  }
}

@end
