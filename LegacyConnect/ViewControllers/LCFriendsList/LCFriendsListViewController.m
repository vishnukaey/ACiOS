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
#import "LCLoadMoreCell.h"

@interface LCFriendsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * friendsList;
@end

static CGFloat kNumberOfSections = 1;
static NSInteger kRowForLoadMoreButton = 1;
static NSString *kFriendsCellIdentifier = @"LCFriendsCell";

@implementation LCFriendsListViewController

#pragma mark - private method implementation
- (void)initialUISetUp {
  [self.navigationController setNavigationBarHidden:NO];
  UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 21)];
  [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  self.navigationItem.backBarButtonItem = backBtnItem;
}

- (void)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)getFriendsList
{
  [LCAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:nil withSuccess:^(id response) {
    [self.friendsList addObjectsFromArray:(NSArray*)response];
  } andfailure:^(NSString *error) {
    
  }];
}

#pragma mark - view lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self initialUISetUp];
  self.friendsList = [[NSMutableArray alloc] init];
  [self getFriendsList];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.friendsList.count + kRowForLoadMoreButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//  if (indexPath.row == self.friendsList.count) {
//    LCLoadMoreCell * friendsCell = [tableView dequeueReusableCellWithIdentifier:kFriendsCellIdentifier forIndexPath:indexPath];
//    if (friendsCell == nil) {
//      friendsCell = [[LCFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsCellIdentifier];
//    }
//    friendsCell.friendObj = [self.friendsList objectAtIndex:indexPath.row];
//    return friendsCell;
//
//  } else {
    LCFriendsCell * friendsCell = [tableView dequeueReusableCellWithIdentifier:kFriendsCellIdentifier forIndexPath:indexPath];
    if (friendsCell == nil) {
      friendsCell = [[LCFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsCellIdentifier];
    }
    friendsCell.friendObj = [self.friendsList objectAtIndex:indexPath.row];
    return friendsCell;
//  }
}


@end
