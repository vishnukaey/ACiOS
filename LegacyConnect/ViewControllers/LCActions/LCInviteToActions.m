//
//  LCInviteToActions.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCInviteToActions.h"
#import "LCViewActions.h"



#pragma mark - LCInviteCommunityFriendCell class
@interface LCInviteCommunityFriendCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *friendNameLabel;
@property(nonatomic, strong)IBOutlet UIImageView *friendPhotoView;
@property(nonatomic, strong)IBOutlet UIButton *checkButton;
@end

@implementation LCInviteCommunityFriendCell
@end

#pragma mark - LCInviteToActions class

@implementation LCInviteToActions
@synthesize eventToInvite;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  NSLog(@"event-->>%@", eventToInvite);
  
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
  
  if (!selectedIDs) {
    selectedIDs = [[NSMutableArray alloc] init];
  }
  NSString *noResultsMessage = NSLocalizedString(@"no_results_found", nil);
  self.noResultsView = [LCUtilityManager getNoResultViewWithText:noResultsMessage andViewWidth:CGRectGetWidth(self.tableView.frame)];
  
  [self startFetchingResults];
}


#pragma mark - API and Pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [super startFetchingResults];
#warning remove hardcoded value
  [LCAPIManager getMemberFriendsForEventID:@"1447139069739" searchKey:searchBar.text lastUserId:nil withSuccess:^(id response) {
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
#warning remove hardcoded value
  [LCAPIManager getMemberFriendsForEventID:@"1447139069739" searchKey:searchBar.text lastUserId:[(LCFriend*)[self.results lastObject] friendId] withSuccess:^(id response) {
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
  NSLog(@"friendsTableView.selectedIDs-->>>%@", selectedIDs);
  [LCAPIManager addUsersWithUserIDs:selectedIDs forEventWithEventID:self.eventToInvite.eventID withSuccess:^(id response){
    NSLog(@"%@",response);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
    LCViewActions *vc = [sb instantiateViewControllerWithIdentifier:@"LCViewActions"];
    vc.eventObject = self.eventToInvite;
    [self.navigationController pushViewController:vc animated:YES];
  }andFailure:^(NSString *error){
    NSLog(@"%@",error);
  }];
}

- (IBAction)backButtonAction
{
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - searchfield delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if (searchTimer)
  {
    if ([searchTimer isValid]) { [searchTimer invalidate]; }
    searchTimer = nil;
  }
  
  searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchRequest:) userInfo:nil repeats:NO];
}

-(void) searchRequest:(NSTimer*)sender
{
  [self startFetchingResults];
}

#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath
  
  static NSString *MyIdentifier = @"LCInviteCommunityFriendCell";
  LCInviteCommunityFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCInviteCommunityFriendCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:MyIdentifier];
  }
  
  LCFriend *friend = self.results[indexPath.row];
  cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
  cell.friendPhotoView.layer.cornerRadius = cell.friendPhotoView.frame.size.width/2;
  [cell.friendPhotoView  sd_setImageWithURL:[NSURL URLWithString:friend.avatarURL] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  
  if ([selectedIDs containsObject:friend.friendId]) {
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [cell.checkButton setSelected:YES];
  }
  else {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [cell.checkButton setSelected:NO];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  LCInviteCommunityFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LCFriend *friend = self.results[indexPath.row];
  [selectedIDs addObject:friend.friendId];
  [cell.checkButton setSelected:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCInviteCommunityFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LCFriend *friend = self.results[indexPath.row];
  [selectedIDs removeObject:friend.friendId];
  [cell.checkButton setSelected:NO];
}
@end