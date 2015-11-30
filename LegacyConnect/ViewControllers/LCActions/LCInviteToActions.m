//
//  LCInviteToActions.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCInviteToActions.h"
#import "LCViewActions.h"
#import "LCActionsForm.h"


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
  LCDLog(@"event-->>%@", eventToInvite);
  
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
  
  if (self.navigationController) {
    isCreatingAction = YES;
    [backButton setHidden:YES];
  }
  else{
    isCreatingAction = NO;
  }

  [self startFetchingResults];
  [self validate];
}

- (void)validate {
  
  if (selectedIDs.count > 0) {
    if (isCreatingAction) {
      [doneButton setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
    }
    else {
      [doneButton setTitle:NSLocalizedString(@"send", nil) forState:UIControlStateNormal];
      [doneButton setEnabled:YES];
    }
  }
  else{
    if (isCreatingAction) {
      [doneButton setTitle:NSLocalizedString(@"skip", nil) forState:UIControlStateNormal];
    }
    else {
      [doneButton setTitle:NSLocalizedString(@"send", nil) forState:UIControlStateNormal];
      [doneButton setEnabled:NO];
    }
  }
}

#pragma mark - API and Pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [super startFetchingResults];
  [LCAPIManager getMemberFriendsForEventID:self.eventToInvite.eventID searchKey:searchBar.text lastUserId:nil withSuccess:^(id response) {
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
  [LCAPIManager getMemberFriendsForEventID:self.eventToInvite.eventID searchKey:searchBar.text lastUserId:[(LCFriend*)[self.results lastObject] friendId] withSuccess:^(id response) {
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
  LCDLog(@"friendsTableView.selectedIDs-->>>%@", selectedIDs);
  if (selectedIDs.count > 0) {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [LCAPIManager addUsersWithUserIDs:selectedIDs forEventWithEventID:self.eventToInvite.eventID withSuccess:^(id response){
      LCDLog(@"%@",response);
      [MBProgressHUD hideHUDForView:self.tableView animated:YES];
      [self dismissInviteActionView];
    }andFailure:^(NSString *error){
      LCDLog(@"%@",error);
      [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
  }
  else {
    [self dismissInviteActionView];
  }
}

- (IBAction)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) dismissInviteActionView{
  
  if (isCreatingAction) {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
    LCViewActions *vc = [sb instantiateViewControllerWithIdentifier:@"LCViewActions"];
    vc.eventObject = self.eventToInvite;
    UINavigationController *nav = [[[self presentingViewController] childViewControllers] objectAtIndex:0];
    [self dismissViewControllerAnimated:NO completion:^{
      [nav pushViewController:vc animated:YES];
    }];
  }
  else {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
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

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//  return self.results.count;
//}

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
  
  //check already invited
  if (friend.isInvitedToEvent) {
    [cell.checkButton setEnabled:NO];
    [cell setUserInteractionEnabled:NO];
  }
  
  //check already selected
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
  [self validate];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCInviteCommunityFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LCFriend *friend = self.results[indexPath.row];
  [selectedIDs removeObject:friend.friendId];
  [cell.checkButton setSelected:NO];
  [self validate];
}
@end