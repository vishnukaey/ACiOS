//
//  LCFeedsCommentsController.m
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsCommentsController.h"
#import "LCCommentCell.h"
#import "LCLoadingCell.h"
#import "LCFullScreenImageVC.h"

static CGFloat kIndexForPostDetails = 0;

@implementation LCFeedsCommentsController
@synthesize feedObject;

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [LCAPIManager getCommentsForPost:feedObject.entityID lastCommentId:nil withSuccess:^(id response, BOOL isMore) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self didFetchResults:response haveMoreData:isMore];
  } andfailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  
  [LCAPIManager getCommentsForPost:feedObject.entityID lastCommentId:[(LCComment*)[self.results lastObject] commentId] withSuccess:^(id response, BOOL isMore) {
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

#pragma mark - feed details API
- (void)fetchFeedDetails
{
  [LCAPIManager getPostDetailsOfPost:self.feedId WithSuccess:^(LCFeed *response) {
    self.feedObject = response;
    [self startFetchingResults];
  } andFailure:^(NSString *error) {
    
  }];
}

#pragma mark - private method implementation
- (void)initialUISetUp
{
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 68.0;
  [commentTitleLabel setText:[[LCUtilityManager performNullCheckAndSetValue:feedObject.firstName] uppercaseString]];
  [self.tableView reloadData];
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  if (self.feedId) {
    [self fetchFeedDetails];
  } else {
    [self startFetchingResults];
  }
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - button actions
-(void)postAction
{
  NSString * commentString = [commentTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
  ;
  if (commentString.length > 0) {
    [self resignAllResponders];
    [self enableCommentField:NO];
    [LCAPIManager commentPost:self.feedObject comment:commentTextField.text withSuccess:^(id response) {
      [self.results insertObject:(LCComment*)response atIndex:0];
      self.feedObject.commentCount = [NSString stringWithFormat:@"%li",(unsigned long)[self.results count]];
      [commentTextField setText:nil];
      [commentTextField_dup setText:nil];
      [self changeUpdateButtonState];
      [self.tableView reloadData];
      [self enableCommentField:YES];
    } andFailure:^(NSString *error) {
      LCDLog(@"----- Fail to add new comment");
      [self enableCommentField:YES];
    }];
  }
}

- (IBAction)backAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [super tableView:tableView numberOfRowsInSection:section] + 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (indexPath.row == kIndexForPostDetails)
  {
    LCFeedCellView *feedCell;
    feedCell = (LCFeedCellView *)[tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
    if (feedCell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
      feedCell = [topLevelObjects objectAtIndex:0];
    }
    [feedCell setData:feedObject forPage:kCommentsfeedCellID];
    __weak typeof(self) weakSelf = self;
    feedCell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
      [weakSelf feedCellActionWithType:actionType andFeed:feed];
    };
    feedCell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
      [weakSelf tagTapped:tagDetails];
    };
    return feedCell;
  }
  else //comment cell
  {
    JTTABLEVIEW_cellForRowAtIndexPath
      LCCommentCell *commentCell;
      static NSString *MyIdentifier = @"LCCommentCell";
      commentCell = (LCCommentCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
      if (commentCell == nil)
      {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCCommentCellXIB" owner:self options:nil];
        commentCell = [topLevelObjects objectAtIndex:0];
      }
      [commentCell setComment:[self.results objectAtIndex:indexPath.row]];
      [commentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
      __weak typeof(self) weakSelf = self;
      commentCell.commentCellTagAction = ^ (NSDictionary * tagDetails) {
        [weakSelf tagTapped:tagDetails];
      };
    [commentCell.seperator setHidden:self.results.count == indexPath.row];
      return commentCell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCDLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed*)feed
{
  if (type == kFeedCellActionComment) {
    if (!commentTextField.isFirstResponder) {
      [commentTextField_dup becomeFirstResponder];
    }
  }
  else if (type == kkFeedCellActionViewImage)
  {
    [self showFullScreenImage:feed];
  }
}

- (void)showFullScreenImage:(LCFeed*)feed
{
  LCFullScreenImageVC *vc = [[LCFullScreenImageVC alloc] init];
  vc.feed = feed;
  vc.commentAction = ^ (id sender, BOOL showComments) {
    [sender dismissViewControllerAnimated:YES completion:nil];
  };
  vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:vc animated:YES completion:nil];
}


@end
