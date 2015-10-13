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
#import <KoaPullToRefresh/KoaPullToRefresh.h>

@interface LCFriendsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * friendsList;
@property (nonatomic, assign) BOOL loadMoreFriends;
@property (nonatomic, assign) BOOL isLoadingMoreFriends;

@end

static CGFloat kNumberOfSections = 1;
static NSInteger kRowForLoadingCell = 1;
static NSInteger kRowHeightFriendsCell= 88;
static NSInteger kRowHeightLoadingCell= 45;
static NSString *kFriendsCellIdentifier = @"LCFriendsCell";
static NSString *kTitle = @"FRIENDS";

@implementation LCFriendsListViewController

#pragma mark - private method implementation
- (void)addPullToRefresh
{
  [self.tableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
  [self.tableView addPullToRefreshWithActionHandler:^{
    [self.friendsList removeAllObjects];
    [self.tableView reloadData];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [self getFriendsListWithLastLastUserId:nil];
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
}

- (void)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)getFriendsListWithLastLastUserId:(NSString*)lastUserId
{
  self.isLoadingMoreFriends = YES;
  [LCAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:lastUserId withSuccess:^(id response) {
    self.loadMoreFriends = ([(NSArray*)response count] > 0) ? YES : NO;
    [self.friendsList addObjectsFromArray:(NSArray*)response];
    if (self.tableView.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
      [self.tableView.pullToRefreshView stopAnimating];
    }
    self.isLoadingMoreFriends = NO;
    [self.tableView reloadData];
  } andfailure:^(NSString *error) {
    NSLog(@"%@",error);
    self.isLoadingMoreFriends = NO;
    self.loadMoreFriends = YES;
  }];
}

#pragma mark - view lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.friendsList = [[NSMutableArray alloc] init];
  self.loadMoreFriends = YES;
  [self getFriendsListWithLastLastUserId:nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (self.friendsList.count == 0) {
    return 1;
  }
  
  return self.friendsList.count + ((self.loadMoreFriends && self.tableView.pullToRefreshView.state != KoaPullToRefreshStateLoading) ?  kRowForLoadingCell : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.friendsList.count == 0)
    {
      return [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"no_friends_available", nil)];
    }
  
  if (indexPath.row == self.friendsList.count) {
    LCLoadingCell * loadingCell = (LCLoadingCell*)[tableView dequeueReusableCellWithIdentifier:[LCLoadingCell getFeedCellidentifier] forIndexPath:indexPath];
    if (loadingCell == nil) {
      loadingCell = [[LCLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[LCLoadingCell getFeedCellidentifier]];
    }
    [MBProgressHUD hideHUDForView:loadingCell animated:YES];
    [MBProgressHUD showHUDAddedTo:loadingCell animated:YES];
    return loadingCell;
  }
  else
  {
    LCFriendsCell * friendsCell = (LCFriendsCell*)[tableView dequeueReusableCellWithIdentifier:kFriendsCellIdentifier forIndexPath:indexPath];
    if (friendsCell == nil) {
      friendsCell = [[LCFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsCellIdentifier];
    }
    friendsCell.friendObj = [self.friendsList objectAtIndex:indexPath.row];
    [friendsCell.changeFriendStatusBtn setTag:indexPath.row];
    [friendsCell.changeFriendStatusBtn addTarget:self action:@selector(changeFriendStatusButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return friendsCell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == self.friendsList.count) {
    return kRowHeightLoadingCell;
  }
  return kRowHeightFriendsCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == self.friendsList.count - 1 && self.loadMoreFriends && !self.isLoadingMoreFriends) {
    [self getFriendsListWithLastLastUserId:[(LCFriend*)[self.friendsList objectAtIndex:self.friendsList.count - 1] friendId]];
  }
}

#pragma mark - add/remove/canel friends.
- (void)changeFriendStatusButtonTapped:(LCfriendButton*)btn
{
  LCFriend * friendObj = [self.friendsList objectAtIndex:btn.tag];
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
       [self.tableView beginUpdates];
       [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
       [self.friendsList removeObject:friendObj];
       [self.tableView endUpdates];
     }
                    andFailure:^(NSString *error)
     {
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
      [self.tableView beginUpdates];
      [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
      [self.friendsList removeObject:friendObj];
      [self.tableView endUpdates];

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

  [friendBtn setfriendStatusButtonImageForStatus:kIsFriend];

  [LCAPIManager sendFriendRequest:friendObj.friendId withSuccess:^(NSArray *response) {
    NSLog(@"%@",response);
    friendObj.isFriend = kFriendStatusMyFriend;
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
    [friendBtn setfriendStatusButtonImageForStatus:(FriendStatus)[friendObj.isFriend integerValue]];
  }];

}

@end
