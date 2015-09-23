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
static NSInteger kRowHeightFriendsCell= 88;
static NSString *kFriendsCellIdentifier = @"LCFriendsCell";
static NSString *kLoadMoreCellIdentifier = @"LCLoadMoreCell";
static NSString *kTitle = @"FRIENDS";

@implementation LCFriendsListViewController

#pragma mark - private method implementation
- (void)initialUISetUp {
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

- (void)getFriendsList
{
  [LCAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:nil withSuccess:^(id response) {
    [self.friendsList addObjectsFromArray:(NSArray*)response];
  } andfailure:^(NSString *error) {
    
  }];
  [self addDummyData];
}

- (void)addDummyData {
  for (int i=0; i <20; i++) {
    LCFriend * friend = [[LCFriend alloc] init];
    friend.firstName = @"jonh";
    friend.lastName = [NSString stringWithFormat:@"jonh %d",i];
    friend.avatarURL = @"https://pbs.twimg.com/media/B__-xpyWMAE2mpw.png";
    friend.isFriend = (i%2 == 0) ? @"Already Friend" : @"Not Friend";
    [self.friendsList addObject:friend];
  }
}


#pragma mark - view lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.friendsList = [[NSMutableArray alloc] init];
  [self getFriendsList];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self initialUISetUp];
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
  return self.friendsList.count + kRowForLoadMoreButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == self.friendsList.count) {
    LCLoadMoreCell * loadMoreCell = [tableView dequeueReusableCellWithIdentifier:kLoadMoreCellIdentifier forIndexPath:indexPath];
    if (loadMoreCell == nil) {
      loadMoreCell = [[LCLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLoadMoreCellIdentifier];
    }
//    loadMoreCell.loadMoreCellTapAction = ^ {
//      NSLog(@"-----> Load more");
//    };
    return loadMoreCell;

  } else {
    LCFriendsCell * friendsCell = (LCFriendsCell*)[tableView dequeueReusableCellWithIdentifier:kFriendsCellIdentifier forIndexPath:indexPath];
    if (friendsCell == nil) {
      friendsCell = [[LCFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsCellIdentifier];
    }
    friendsCell.friendObj = [self.friendsList objectAtIndex:indexPath.row];
    return friendsCell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kRowHeightFriendsCell;
}

@end
