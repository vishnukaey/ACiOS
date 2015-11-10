//
//  LCFriendsListViewController.m
//  LegacyConnect
//
//  Created by qbuser on 21/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFriendsListViewController.h"
#import "LCFriendsCell.h"
#import "LCAPIManager.h"
#import "LCLoadingCell.h"
#import "LCProfileViewVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>

static CGFloat kNumberOfSections = 1;
static NSInteger kRowHeightFriendsCell= 88;
static NSString *kFriendsCellIdentifier = @"LCFriendsCell";
static NSString *kTitle = @"FRIENDS";

@implementation LCFriendsListViewController

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [LCAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:nil withSuccess:^(id response) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchResults:response haveMoreData:hasMoreData];
    [self setNoResultViewHidden:[(NSArray*)response count] != 0];
  } andfailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
    [self setNoResultViewHidden:[self.results count] != 0];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:[(LCFriend*)[self.results lastObject] friendId] withSuccess:^(id response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    [self didFailedToFetchResults];
  }];
}

- (void)setNoResultViewHidden:(BOOL)hidded
{
  if (hidded) {
    [self hideNoResultsView];
  }
  else{
    [self showNoResultsView];
  }
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
  [self.tableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
  __weak typeof(self) weakSelf = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    [weakSelf setNoResultViewHidden:YES];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [weakSelf startFetchingResults];
    });
  }withBackgroundColor:[UIColor lightGrayColor]];
}

- (void)initialUISetUp
{
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:40.0f/255.0 green:40.0f/255.0 blue:40.0f/255.0 alpha:1.0]];
  [self.navigationController setNavigationBarHidden:NO];
  self.title = kTitle;
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
  UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 21)];
  [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  self.navigationItem.leftBarButtonItem = backBtnItem;
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:NSLocalizedString(@"no_friends_available", nil) andViewWidth:CGRectGetWidth(self.tableView.frame)];
  self.nextPageLoaderCell = [LCUtilityManager getNextPageLoaderCell];
}

#pragma mark - Button actions
- (void)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - view lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self initialUISetUp];
  [self addPullToRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
  self.navigationController.navigationBarHidden = true;
  [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return kNumberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath

  LCFriendsCell * friendsCell = (LCFriendsCell*)[tableView dequeueReusableCellWithIdentifier:kFriendsCellIdentifier forIndexPath:indexPath];
  if (friendsCell == nil) {
    friendsCell = [[LCFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsCellIdentifier];
  }
  friendsCell.friendObj = [self.results objectAtIndex:indexPath.row];
  [friendsCell.changeFriendStatusBtn setTag:indexPath.row];
  [friendsCell.changeFriendStatusBtn addTarget:self action:@selector(changeFriendStatusButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  return friendsCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kRowHeightFriendsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
  LCProfileViewVC *vc = [sb instantiateInitialViewController];
  vc.userDetail = [[LCUserDetail alloc] init];
  LCFriend *friend = [self.results objectAtIndex:indexPath.row];
  vc.userDetail.userID = friend.friendId;
  [self.navigationController pushViewController:vc animated:YES];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - add/remove/canel friends.
- (void)changeFriendStatusButtonTapped:(LCfriendButton*)btn
{
  LCFriend * friendObj = [self.results objectAtIndex:btn.tag];
  FriendStatus status = (FriendStatus)[friendObj.isFriend integerValue];
  
  switch (status) {
    case kIsFriend:
      [self removeUserFriend:friendObj andFriendButton:btn];
      break;
      
    case kRequestWaiting:
      [self cancelFriendRequest:friendObj andFriendButton:btn];
      break;
      
    case kNonFriend:
      [self addFriend:friendObj andFriendButton:btn];
      break;
      
    default:
      break;
  }
}

- (void)removeUserFriend:(LCFriend*)friendObj andFriendButton:(LCfriendButton*)btn
{
  LCfriendButton * friendBtn = btn;
  //remove friend
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *removeFriend = [UIAlertAction actionWithTitle:@"Remove Friend" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    //change button image
    [friendBtn setfriendStatusButtonImageForStatus:kNonFriend];
    [LCAPIManager removeFriend:friendObj.friendId withSuccess:^(NSArray *response)
     {
       friendObj.isFriend = kFriendStatusNonFriend;
    
     } andFailure:^(NSString *error) {
       //Set previous button state
       [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
       NSLog(@"%@",error);
     }];
  }];
  [actionSheet addAction:removeFriend];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)cancelFriendRequest:(LCFriend*)friendObj andFriendButton:(LCfriendButton*)btn
{
  //cancel friend request
  LCfriendButton * friendBtn = btn;
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *cancelFreindRequest = [UIAlertAction actionWithTitle:@"Cancel Friend Request" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    [friendBtn setfriendStatusButtonImageForStatus:kNonFriend];
    [LCAPIManager cancelFriendRequest:friendObj.friendId withSuccess:^(NSArray *response) {
      NSLog(@"%@",response);
      friendObj.isFriend = kFriendStatusNonFriend;
    } andFailure:^(NSString *error) {
      //Set previous button state
      [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
      NSLog(@"%@",error);
    }];
  }];
  [actionSheet addAction:cancelFreindRequest];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)addFriend:(LCFriend*)friendObj andFriendButton:(LCfriendButton*)btn
{
  LCfriendButton * friendBtn = btn;
  [friendBtn setfriendStatusButtonImageForStatus:kRequestWaiting];
  
  [LCAPIManager sendFriendRequest:friendObj.friendId withSuccess:^(NSArray *response) {
    NSLog(@"%@",response);
    friendObj.isFriend = kFriendStatusWaiting;
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
    [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
  }];
}

@end
