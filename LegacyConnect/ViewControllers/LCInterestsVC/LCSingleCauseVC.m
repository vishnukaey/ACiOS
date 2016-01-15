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
#import "LCSingleInterestVC.h"

@implementation LCSingleCauseVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialSetUp];
  [self refreshViewWithCauseDetails];
  [self fetchCauseDetails];
  [self startFetchingResults];
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
  [LCThemeAPIManager getCauseDetailsOfCause:self.cause.causeID WithSuccess:^(LCCause *response) {
    self.cause = response;
    [self refreshViewWithCauseDetails];
  } andFailure:^(NSString *error) {
  }];
}


-(void)refreshViewWithCauseDetails
{
  causeNameLabel.text = self.cause.name;
  causeDescriptionLabel.text = self.cause.tagLine;
  navigationBar.title.text =[[LCUtilityManager performNullCheckAndSetValue: self.cause.name] uppercaseString];
  [causeImageView sd_setImageWithURL:[NSURL URLWithString:self.cause.logoURLSmall] placeholderImage:nil];
  causeNameLabel.text = [NSString stringWithFormat:@"%@",[self.cause.name uppercaseString]];
  [causeSupportersCountButton setTitle:[NSString stringWithFormat:@"%@ Followers",[LCUtilityManager performNullCheckAndSetValue:self.cause.supporters]] forState:UIControlStateNormal];
  
  //  [causeURLLabel setText:@""];
  
  if(self.cause.isSupporting)
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
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"no_feeds_available", nil)];
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
  [LCThemeAPIManager getPostsInCause:self.cause.causeID andLastPostID:nil withSuccess:^(NSArray *response) {
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
  [LCThemeAPIManager getPostsInCause:self.cause.causeID andLastPostID:[(LCFeed*)[self.results lastObject] entityID] withSuccess:^(NSArray *response) {
    [self stopRefreshingViews];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
    [self reloadPostsTable];
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
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
//  if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeCause])//go to cause page
//  {
//    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
//    LCSingleCauseVC *causeVC = [interestSB instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
//    causeVC.cause.interestID = tagDetails[kTagobjId];
//    [self.navigationController pushViewController:causeVC animated:YES];
//  }
//  else
  if ([tagDetails[kTagobjType] isEqualToString:kFeedTagTypeUser])//go to user page
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
    [LCThemeAPIManager supportCause:self.cause.causeID withSuccess:^(id response) {
      self.cause.isSupporting =YES;
      self.cause.supporters = [NSString stringWithFormat:@"%d",[self.cause.supporters intValue]+1];
      supportButton.userInteractionEnabled = YES;
    } andFailure:^(NSString *error) {
      [supportButton setSelected:NO];
      supportButton.userInteractionEnabled = YES;
    }];
  }
  else
  {
    [supportButton setSelected:NO];
    [LCThemeAPIManager unsupportCause:self.cause.causeID withSuccess:^(id response) {
      supportButton.userInteractionEnabled = YES;
      self.cause.isSupporting = NO;
      self.cause.supporters = [NSString stringWithFormat:@"%d",[self.cause.supporters intValue]-1];
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
  vc.cause = self.cause;
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
