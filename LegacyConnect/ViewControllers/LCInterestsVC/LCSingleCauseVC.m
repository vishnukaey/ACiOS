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
  [self initialSetUp];
  [self refreshViewWithCauseDetails];
  [self fetchCauseDetails];
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

-(void)fetchCauseDetails
{
  [LCThemeAPIManager getCauseDetailsOfCause:_cause.causeID WithSuccess:^(LCCause *response) {
    _cause = response;
    [self refreshViewWithCauseDetails];
  } andFailure:^(NSString *error) {
  }];
}


-(void)refreshViewWithCauseDetails
{
  causeNameLabel.text = _cause.name;
  causeDescriptionLabel.text = _cause.tagLine;
  navigationBar.title.text =[[LCUtilityManager performNullCheckAndSetValue: _cause.name] uppercaseString];
  [causeImageView sd_setImageWithURL:[NSURL URLWithString:_cause.logoURLSmall] placeholderImage:nil];
  causeNameLabel.text = [NSString stringWithFormat:@"%@",[_cause.name uppercaseString]];
  [causeSupportersCountButton setTitle:[NSString stringWithFormat:@"%@ Followers",[LCUtilityManager performNullCheckAndSetValue:_cause.supporters]] forState:UIControlStateNormal];
  
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


#pragma mark - private method implementation

- (void)initialSetUp
{
  causeImageView.layer.cornerRadius = 5.0;
  supportButton.layer.cornerRadius = 5.0;
  causeSupportersCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  causeURLButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self addPullToRefreshForPostsTable];
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


- (IBAction)supportClicked:(id)sender
{
  NSLog(@"Follow clicked");
  
  supportButton.userInteractionEnabled = NO;
  if(!supportButton.selected)
  {
    [supportButton setSelected:YES];
    [LCThemeAPIManager supportCause:_cause.causeID withSuccess:^(id response) {
      _cause.isSupporting =YES;
      _cause.supporters = [NSString stringWithFormat:@"%d",[_cause.supporters intValue]+1];
      supportButton.userInteractionEnabled = YES;
    } andFailure:^(NSString *error) {
      [supportButton setSelected:NO];
      supportButton.userInteractionEnabled = YES;
    }];
  }
  else
  {
    [supportButton setSelected:NO];
    [LCThemeAPIManager unsupportCause:_cause.causeID withSuccess:^(id response) {
      supportButton.userInteractionEnabled = YES;
      _cause.isSupporting = NO;
      _cause.supporters = [NSString stringWithFormat:@"%d",[_cause.supporters intValue]-1];
    } andFailure:^(NSString *error) {
      supportButton.userInteractionEnabled = YES;
      [supportButton setSelected:YES];
    }];
  }
}

- (IBAction)supportersListClicked:(id)sender
{
  NSLog(@"FollowList clicked");
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
  LCCauseSupportersVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCCauseSupportersVC"];
  vc.cause = _cause;
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)websiteLinkClicked:(id)sender
{
  NSLog(@"Follow clicked");
//  if (_cause.url) {
//    NSURL * websiteURL = [NSURL HTTPURLFromString:self.eventObject.website];
//    if ([[UIApplication sharedApplication] canOpenURL:websiteURL]) {
//      [[UIApplication sharedApplication] openURL:websiteURL];
//    }
//  }
}


- (IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ScrollView Custom Delelgate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGFloat viewHeight = 320.0;
  
  if (scrollView.contentOffset.y <= 0 && collapseViewHeight.constant >= viewHeight) //Added this line to KOAPullToRefresh to work correctly.
  {
    return;
  }
  
  float collapseConstant = 0;;
  if (collapseViewHeight.constant > 0)
  {
    collapseConstant = collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseViewHeight.constant < viewHeight && scrollView.contentOffset.y < 0)
  {
    collapseConstant = collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseConstant < 0)
  {
    collapseConstant = 0;
  }
  if (collapseConstant > viewHeight)
  {
    collapseConstant = viewHeight;
  }
  collapseViewHeight.constant = collapseConstant;
}


@end
