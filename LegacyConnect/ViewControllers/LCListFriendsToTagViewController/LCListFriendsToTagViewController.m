//
//  LCListFriendsToTagViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCListFriendsToTagViewController.h"
#import "LCContactsListVC.h"

#pragma mark - LCIviteContacts class
@interface LCInviteContactsCell2 : UITableViewCell
@end

@implementation LCInviteContactsCell2
@end

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
  
  if (!self.selectedFriends) {
    self.selectedFriends = [[NSMutableArray alloc] init];
  }
  for (LCFriend *friend in alreadySelectedFriends)
  {
    [self.selectedFriends addObject:friend];
  }
//  NSString *noResultsMessage = NSLocalizedString(@"no_results_found", nil);
//  self.noResultsView = [LCPaginationHelper getNoResultViewWithText:noResultsMessage];
  
  [self startFetchingResults];
}

#pragma mark - API and Pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [super startFetchingResults];
  int pageNumber = (int)self.results.count/10+1;
  
  [LCProfileAPIManager getFriendsForUser:[LCDataManager sharedDataManager].userID searchKey:_searchKey lastUserId:nil andPageNumber:[NSString stringWithFormat:@"%d",pageNumber] withSuccess:^(id response) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
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
  
  int pageNumber = (int)self.results.count/kPaginationFactor+1;
  
  [LCProfileAPIManager getFriendsForUser:[LCDataManager sharedDataManager].userID searchKey:_searchKey lastUserId:[(LCFriend*)[self.results lastObject] friendId] andPageNumber:[NSString stringWithFormat:@"%d",pageNumber] withSuccess:^(id response) {
    BOOL hasMoreData = [(NSArray*)response count] >= 10;
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
  [delegate didFinishPickingFriends:self.selectedFriends];
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
  searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchRequest) userInfo:nil repeats:NO];
}


-(void) searchRequest
{
  [self startFetchingResults];
}

#pragma mark - TableView delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if(section == 0)
  {
    return self.results.count;
  }
  else
  {
    return 1;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == 0)
  {
    return 76.0;
  }
  else
  {
    return 90;
  }
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == 0)
  {
    JTTABLEVIEW_cellForRowAtIndexPath
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
    
    if ([self.selectedFriends containsObject:friend])
    {
      [cell.checkButton setSelected:YES];
    }
    else
    {
      [cell.checkButton setSelected:NO];
    }
    
    return cell;
  }
  else
  {
    static NSString *cellIdentifier = @"LCInviteContactsCell";
    LCInviteContactsCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
      cell = [[LCInviteContactsCell2 alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
    }
    return cell;
  }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == 0)
  {
    LCTagFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LCFriend *friend = self.results[indexPath.row];
    
    if(cell.checkButton.selected)
    {
      [self.selectedFriends removeObject:friend];
      [cell.checkButton setSelected:NO];
      
    }
    else
    {
      [self.selectedFriends addObject:friend];
      [cell.checkButton setSelected:YES];
    }
  }
  else
  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
    LCContactsListVC *contacts = [storyboard instantiateViewControllerWithIdentifier:@"ContactList"];
    [self.navigationController pushViewController:contacts animated:YES];
  }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  if(indexPath.section == 0)
  {
    LCTagFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LCFriend *friend = self.results[indexPath.row];
    
    if(cell.checkButton.selected)
    {
      [self.selectedFriends removeObject:friend];
      [cell.checkButton setSelected:NO];
      
    }
    else
    {
      [self.selectedFriends addObject:friend];
      [cell.checkButton setSelected:YES];
    }
  }
  else
  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
    LCContactsListVC *contacts = [storyboard instantiateViewControllerWithIdentifier:@"ContactList"];
    [self.navigationController pushViewController:contacts animated:YES];
  }
}


-(IBAction)inviteFriendsFromContacts:(id)sender
{
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  LCContactsListVC *contacts = [storyboard instantiateViewControllerWithIdentifier:@"ContactList"];
  [self.navigationController pushViewController:contacts animated:YES];
  
}

@end
