//
//  LCSingleCauseVC.m
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSingleCauseVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import "LCFeedCellView.h"
#import "LCFeedsCommentsController.h"
#import "LCFullScreenImageVC.h"
#import "LCProfileViewVC.h"
#import "LCCauseSupportersVC.h"


@implementation LCSingleCauseVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self refreshViewWithCauseDetails];
  //  [self prepareCells];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
  self.navigationController.navigationBarHidden = YES;
}

-(void)refreshViewWithCauseDetails
{
  causeImageView.layer.cornerRadius = 5.0;
  supportButton.layer.cornerRadius = 5.0;
  causeSupportersCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  causeURLButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

  causeNameLabel.text = _cause.name;
  causeDescriptionLabel.text = _cause.tagLine;
  [causeImageView sd_setImageWithURL:[NSURL URLWithString:_cause.logoURLSmall] placeholderImage:nil];
  causeNameLabel.text = [NSString stringWithFormat:@"%@",[_cause.name uppercaseString]];
  
  [causeSupportersCountButton setTitle:[NSString stringWithFormat:@"%@ Followers",_cause.supporters] forState:UIControlStateNormal];
  
  //  [causeURLLabel setText:@""];
  
  if(_cause.isSupporting)
  {
    [supportButton setSelected:YES];
  }
  else
  {
    [supportButton setSelected:NO];
  }
}

////////


#pragma mark - private method implementation

- (void)initialSetUp
{
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  cellsViewArray = [[NSMutableArray alloc]init];
  for (int i=0; i<feedsArray.count; i++)
  {
    LCFeedCellView *celViewFinal = [[LCFeedCellView alloc]init];
    //    [celViewFinal arrangeSelfForData:[feedsArray objectAtIndex:i] forWidth:feedsTable.frame.size.width forPage:kHomefeedCellID];
    __weak typeof(self) weakSelf = self;
    celViewFinal.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
      [weakSelf feedCellActionWithType:actionType andFeed:feed];
    };
    celViewFinal.feedCellTagAction = ^ (NSDictionary * tagDetails) {
      [weakSelf tagTapped:tagDetails];
    };
    
    [cellsViewArray addObject:celViewFinal];
  }
}


- (void)stopRefreshingViews
{
  //-- Stop Refreshing Views -- //
  if (self.tableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
    [self.tableView.pullToRefreshView stopAnimating];
  }
}


- (void)addPullToRefreshForPostsTable
{
  NSLog(@"FollowList clicked");
}

- (void) loadPostsInCurrentInterest {
  [self startFetchingResults];
}

#pragma mark - API and Pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [super startFetchingResults];
  [LCUserProfileAPIManager getMilestonesForUser:@"5598" andLastMilestoneID:nil withSuccess:^(NSArray *response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
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
  [LCUserProfileAPIManager getMilestonesForUser:@"5598" andLastMilestoneID:[(LCFeed*)[self.results lastObject] entityID] withSuccess:^(NSArray *response) {
    [self stopRefreshingViews];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
    [self reloadPostsTable];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
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

- (void)reloadPostsTable
{
  [self.tableView reloadData];
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
  
  
  tableView.backgroundColor = [UIColor clearColor];
  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  tableView.allowsSelection = YES;
  
  return cell;
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  switch (type) {
      //    case kkFeedCellActionLoadMore:
      //      [self feedCellMoreAction :feed];
      //      break;
      
    case kkFeedCellActionViewImage:
      [self showFullScreenImage:feed];
      break;
      
    case kFeedCellActionComment:
      [self showFeedCommentsWithFeed:feed];
      
    default:
      break;
  }
}

- (void)showFeedCommentsWithFeed:(LCFeed*)feed
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                bundle:nil];
  LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
  [next setFeedObject:feed];
//  UIViewController *profileController = (UIViewController *)self.delegate;
  [self.navigationController pushViewController:next animated:YES];
}

- (void)showFullScreenImage:(LCFeed*)feed
{
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
      [self reloadPostsTable];
    }
  }];
}


- (void)tagTapped:(NSDictionary *)tagDetails
{
  if ([tagDetails[@"type"] isEqualToString:kFeedTagTypeUser])//go to user page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
  }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
