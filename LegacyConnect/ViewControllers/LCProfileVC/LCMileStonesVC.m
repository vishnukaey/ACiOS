//
//  LCMileStonesVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCMileStonesVC.h"
#import "LCProfileViewVC.h"
#import "LCCreatePostViewController.h"
#import "LCFeedCellView.h"
#import "LCFeedsCommentsController.h"
#import "LCFullScreenImageVC.h"
#import "LCSingleCauseVC.h"
#import "LCSingleInterestVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>

@interface LCMileStonesVC ()

@end

@implementation LCMileStonesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self initialSetUp];
  [self addPullToRefreshForMileStonesTable];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self reloadMilestonesTable];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private method implementation

- (void)initialSetUp
{
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
//  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [LCUtilityManager getHeightOffsetForGIB])];
  self.isSelfProfile = [self.userID isEqualToString:[LCDataManager sharedDataManager].userID];
  
  if (!self.noResultsView) {
    NSString *message = NSLocalizedString(@"no_milestones_available_others", nil);
    if (self.isSelfProfile) {
      message = NSLocalizedString(@"no_milestones_available_self", nil);
    }
    self.noResultsView = [LCUtilityManager getNoResultViewWithText:message andViewWidth:CGRectGetWidth(self.tableView.frame)];
  }
}

- (void)stopRefreshingViews
{
  //-- Stop Refreshing Views -- //
  if (self.tableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
    [self.tableView.pullToRefreshView stopAnimating];
  }
}

- (void)addPullToRefreshForMileStonesTable
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

- (void) loadMileStones {
  [self startFetchingResults];
}

#pragma mark - API and Pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [super startFetchingResults];
  [LCUserProfileAPIManager getMilestonesForUser:self.userID andLastMilestoneID:nil withSuccess:^(NSArray *response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchResults:response haveMoreData:hasMoreData];
    [self setNoResultViewHidden:[(NSArray*)response count] != 0];
    [self reloadMilestonesTable];
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
  [LCUserProfileAPIManager getMilestonesForUser:self.userID andLastMilestoneID:[(LCFeed*)[self.results lastObject] entityID] withSuccess:^(NSArray *response) {
    [self stopRefreshingViews];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
    [self reloadMilestonesTable];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
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
  
  
  if (self.isSelfProfile) {
    cell.moreButton.hidden = NO;
  }
  
  tableView.backgroundColor = [UIColor clearColor];
  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  tableView.allowsSelection = YES;
  
  return cell;
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  switch (type) {
    case kkFeedCellActionLoadMore:
      [self feedCellMoreAction :feed];
      break;
      
    case kkFeedCellActionViewImage:
      [self showFullScreenImage:feed];
      break;
      
    case kFeedCellActionComment:
      [self showFeedCommentsWithFeed:feed];
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
  UIViewController *profileController = (UIViewController *)self.delegate;
  [profileController.navigationController pushViewController:next animated:YES];
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
      [self reloadMilestonesTable];
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
  
  UIAlertAction *removeMilestone = [UIAlertAction actionWithTitle:@"Remove Milestone" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [LCPostAPIManager removeMilestoneFromPost:feed withSuccess:^(NSArray *response) {
      [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    }
                               andFailure:^(NSString *error) {
                                 [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                                 NSLog(@"%@",error);
                               }];
  }];
  [actionSheet addAction:removeMilestone];
  
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

- (void)tagTapped:(NSDictionary *)tagDetails
{
  if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeCause])//go to cause page
  {
    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
    LCSingleCauseVC *causeVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    causeVC.cause.interestID = tagDetails[kTagobjId];
    [self.navigationController pushViewController:causeVC animated:YES];
  }
  else if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeUser])//go to user page
  {
    UIStoryboard*  profileSB = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *profileVC = [profileSB instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    profileVC.userDetail = [[LCUserDetail alloc] init];
    profileVC.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:profileVC animated:YES];
  }
  else if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeInterest])//go to interest page
  {
    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
    LCSingleInterestVC *interestVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
    interestVC.interest = [[LCInterest alloc] init];
    interestVC.interest.interestID = tagDetails[kTagobjId];
    [self.navigationController pushViewController:interestVC animated:YES];
  }
}

#pragma mark - ScrollView delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.delegate scrollViewScrolled:scrollView];
}

@end
