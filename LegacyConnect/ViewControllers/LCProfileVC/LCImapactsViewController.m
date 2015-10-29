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

@interface LCImapactsViewController ()

@end

@implementation LCImapactsViewController
@synthesize impactsTableView, customNavigationHeight, userDetail;

#pragma mark - private method implementation
- (void)addPullToRefresh
{
  [self.impactsTableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
  [self.impactsTableView addPullToRefreshWithActionHandler:^{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [self loadImpactsWithLastId:nil];
    });
  }withBackgroundColor:[UIColor lightGrayColor]];
}

- (void)loadImpactsWithLastId:(NSString*)lastId
{
  [LCAPIManager getImpactsForUser:userDetail.userID andLastMilestoneID:lastId with:^(NSArray *response) {
    // -- Stop Refreshing Views -- //
    if (self.impactsTableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
      [impactsArray removeAllObjects];
      [self.impactsTableView.pullToRefreshView stopAnimating];
      [impactsTableView reloadData];
    }
    [impactsArray addObjectsFromArray:response];
    [impactsTableView reloadData];
    [MBProgressHUD hideHUDForView:impactsTableView animated:YES];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
    [MBProgressHUD hideHUDForView:impactsTableView animated:YES];
  }];
}


#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  self.customNavigationHeight.constant = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
  
  [impactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  impactsTableView.estimatedRowHeight = 44.0;
  impactsTableView.rowHeight = UITableViewAutomaticDimension;
  
  [self addPullToRefresh];
  impactsArray= [[NSMutableArray alloc] init];
  [MBProgressHUD showHUDAddedTo:impactsTableView animated:YES];
  [self loadImpactsWithLastId:nil];
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
  // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (IBAction)backButtonAction
{
  [self.navigationController popViewControllerAnimated:YES];
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
  
  
  UIAlertAction *deletePost = [UIAlertAction actionWithTitle:@"Delete Post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    [MBProgressHUD showHUDAddedTo:impactsTableView animated:YES];
    [LCAPIManager deletePost:feed.entityID withSuccess:^(NSArray *response) {
      [MBProgressHUD hideAllHUDsForView:impactsTableView animated:YES];
    }
                  andFailure:^(NSString *error) {
                    [MBProgressHUD hideAllHUDsForView:impactsTableView animated:YES];
                    NSLog(@"%@",error);
                  }];
  }];
  [actionSheet addAction:deletePost];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (impactsArray.count == 0) {
    return 1;
  }
  return impactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (impactsArray.count == 0)
  {
    NSString *nativeUserId = [LCDataManager sharedDataManager].userID;
    if ([nativeUserId isEqualToString:userDetail.userID])//self profile
    {
      return [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"no_impacts_available_self", nil)];
    }
    else
    {
      return [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"no_impacts_available_others", nil)];
    }
  }
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = [topLevelObjects objectAtIndex:0];
  }
  [cell setData:[impactsArray objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
  __weak typeof(self) weakSelf = self;
  cell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
    [weakSelf feedCellActionWithType:actionType andFeed:feed];
  };
  cell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
    [weakSelf tagTapped:tagDetails];
  };

  //self profile check
  if ([userDetail.isFriend integerValue] == 0) {
    
    cell.moreButton.hidden = NO;
  }


  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
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
      [impactsTableView reloadData];
    }
  }];
}


- (void)tagTapped:(NSDictionary *)tagDetails
{
  NSLog(@"tag details-->>%@", tagDetails);
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
