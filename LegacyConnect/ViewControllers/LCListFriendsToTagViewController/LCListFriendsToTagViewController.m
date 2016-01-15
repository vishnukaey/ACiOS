//
//  LCListFriendsToTagViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCListFriendsToTagViewController.h"



#pragma mark - LCInviteCommunityFriendCell class
@interface LCTagFriendsTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *friendNameLabel;
@property(nonatomic, strong)IBOutlet UIImageView *friendPhotoView;
@property(nonatomic, strong)IBOutlet UIButton *checkButton;
@end

@implementation LCTagFriendsTableViewCell
@end

#pragma mark - LCListFriendsToTagViewController class

@implementation LCListFriendsToTagViewController
@synthesize delegate, alreadySelectedFriends;
#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
  [self initialSerup];
  
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
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

#pragma mark - setup functions
- (void) initialSerup {
  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  if (!self.selectedIDs) {
    self.selectedIDs = [[NSMutableArray alloc] init];
  }
  for (LCFriend *friend in alreadySelectedFriends)
  {
    [self.selectedIDs addObject:friend.friendId];
  }
  NSString *noResultsMessage = NSLocalizedString(@"no_results_found", nil);
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:noResultsMessage];
  
  [self startFetchingResults];
}
//- (void) loadFriendsList
//{
//  [MBProgressHUD showHUDAddedTo:friendsTableView.superview animated:YES];
//  [LCAPIManager getFriendsForUser:[LCDataManager sharedDataManager].userID searchKey:nil lastUserId:nil withSuccess:^(id response) {
//    friendsArray = response;
//    [searchResultsArray addObjectsFromArray:response];
//    [friendsTableView reloadData];
//    [MBProgressHUD hideAllHUDsForView:friendsTableView.superview animated:YES];
//  } andfailure:^(NSString *error) {
//    NSLog(@"%@",error);
//    [MBProgressHUD hideAllHUDsForView:friendsTableView.superview animated:YES];
//  }];
//}

#pragma mark - API and Pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [super startFetchingResults];
  [LCProfileAPIManager getFriendsForUser:[LCDataManager sharedDataManager].userID searchKey:_searchKey lastUserId:nil withSuccess:^(id response) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchResults:response haveMoreData:hasMoreData];
    [self setNoResultViewHidden:[(NSArray*)response count] != 0];
  } andfailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self didFailedToFetchResults];
    [self setNoResultViewHidden:[self.results count] != 0];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCProfileAPIManager getFriendsForUser:[LCDataManager sharedDataManager].userID searchKey:_searchKey lastUserId:[(LCFriend*)[self.results lastObject] friendId] withSuccess:^(id response) {
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
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


#pragma mark - button actions
-(IBAction)doneButtonAction
{
  NSMutableArray *arrayToPass = [[NSMutableArray alloc] init];
  for (NSString *userId in self.selectedIDs)
  {
    for (LCFriend *friend in self.results)
    {
      if ([friend.friendId isEqualToString:userId])
      {
        [arrayToPass addObject:friend];
        break;
      }
    }
  }
  [delegate didFinishPickingFriends:arrayToPass];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - searchfield delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if (searchTimer)
  {
    if ([searchTimer isValid]) { [searchTimer invalidate]; }
    searchTimer = nil;
  }
  _searchKey = [LCUtilityManager getSpaceTrimmedStringFromString:searchText];
  searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchRequest:) userInfo:nil repeats:NO];
}


-(void) searchRequest:(NSTimer*)sender
{
  [self startFetchingResults];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"LCTagFriendsTableViewCell";
  LCTagFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCTagFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:MyIdentifier];
  }
  LCFriend *friend = self.results[indexPath.row];
  cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
  cell.friendPhotoView.layer.cornerRadius = cell.friendPhotoView.frame.size.width/2;
  [cell.friendPhotoView  sd_setImageWithURL:[NSURL URLWithString:friend.avatarURL] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];

  if ([self.selectedIDs containsObject:friend.friendId]) {
    [cell.checkButton setSelected:YES];
  }
  else {
    [cell.checkButton setSelected:NO];
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  LCTagFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LCFriend *friend = self.results[indexPath.row];
  [self.selectedIDs addObject:friend.friendId];
  [cell.checkButton setSelected:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCTagFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LCFriend *friend = self.results[indexPath.row];
  [self.selectedIDs removeObject:friend.friendId];
  [cell.checkButton setSelected:NO];
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
