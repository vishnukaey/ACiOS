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
static NSInteger kFriendsCellHeight= 88;
static NSString *kFriendsCellID = @"LCFriendsCell";

@implementation LCFriendsListViewController

#pragma mark - API calls and Pagination
- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  
  //lll
  int pageNumber = (int)self.results.count/kPaginationFactor;
  [LCProfileAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:nil andPageNumber:[NSString stringWithFormat:@"%d",pageNumber] withSuccess:^(id response) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = [(NSArray*)response count] >= kPaginationFactor;
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
  
  //lll
  int pageNumber = (int)self.results.count/kPaginationFactor;
  [LCProfileAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:[(LCFriend*)[self.results lastObject] friendId] andPageNumber:[NSString stringWithFormat:@"%d",pageNumber] withSuccess:^(id response) {
    [self stopRefreshingViews];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = [(NSArray*)response count] >= kPaginationFactor;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
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
  self.noResultsView = [LCPaginationHelper getNoResultViewWithText:NSLocalizedString(@"no_friends_available", nil)];
  self.nextPageLoaderCell = [LCPaginationHelper getNextPageLoaderCell];
}

#pragma mark - Button actions
- (IBAction)backButtonTapped:(id)sender
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

  LCFriendsCell * friendsCell = (LCFriendsCell*)[tableView dequeueReusableCellWithIdentifier:kFriendsCellID forIndexPath:indexPath];
  if (friendsCell == nil) {
    friendsCell = [[LCFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsCellID];
  }
  friendsCell.friendObj = [self.results objectAtIndex:indexPath.row];
  [friendsCell.changeFriendStatusBtn setTag:indexPath.row];
  [friendsCell.changeFriendStatusBtn addTarget:self action:@selector(changeFriendStatusButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  return friendsCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kFriendsCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UIStoryboard*  profileSB = [UIStoryboard storyboardWithName:kProfileSID bundle:nil];
  LCProfileViewVC *profileVC = [profileSB instantiateInitialViewController];
  profileVC.userDetail = [[LCUserDetail alloc] init];
  LCFriend *friend = [self.results objectAtIndex:indexPath.row];
  profileVC.userDetail.userID = friend.friendId;
  [self.navigationController pushViewController:profileVC animated:YES];
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
  
  UIAlertAction *removeFriend = [UIAlertAction actionWithTitle:NSLocalizedString(@"remove_friend", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    //change button image
    [friendBtn setfriendStatusButtonImageForStatus:kNonFriend];
    friendBtn.userInteractionEnabled = NO;
    [LCProfileAPIManager removeFriend:friendObj.friendId withSuccess:^(NSArray *response)
     {
       friendBtn.userInteractionEnabled = YES;
     } andFailure:^(NSString *error) {
       //Set previous button state
       [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
       friendBtn.userInteractionEnabled = YES;
     }];
  }];
  [actionSheet addAction:removeFriend];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)cancelFriendRequest:(LCFriend*)friendObj andFriendButton:(LCfriendButton*)btn
{
  //cancel friend request
  LCfriendButton * friendBtn = btn;
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *cancelFreindRequest = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel_friend_request", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    [friendBtn setfriendStatusButtonImageForStatus:kNonFriend];
    friendBtn.userInteractionEnabled = NO;
    [LCProfileAPIManager cancelFriendRequest:friendObj.friendId withSuccess:^(NSArray *response) {
      friendBtn.userInteractionEnabled = YES;
    } andFailure:^(NSString *error) {
      //Set previous button state
      [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
      friendBtn.userInteractionEnabled = YES;
    }];
  }];
  [actionSheet addAction:cancelFreindRequest];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)addFriend:(LCFriend*)friendObj andFriendButton:(LCfriendButton*)btn
{
  LCfriendButton * friendBtn = btn;
  [friendBtn setfriendStatusButtonImageForStatus:kRequestWaiting];
  friendBtn.userInteractionEnabled = NO;
  [LCProfileAPIManager sendFriendRequest:friendObj.friendId withSuccess:^(NSDictionary *response) {
    friendBtn.userInteractionEnabled = YES;
  } andFailure:^(NSString *error) {
    [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
    friendBtn.userInteractionEnabled = YES;
  }];
}

@end
