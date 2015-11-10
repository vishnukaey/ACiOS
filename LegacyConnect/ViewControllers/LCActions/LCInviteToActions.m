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
  [self loadFriendsList];
  searchResultsArray = [[NSMutableArray alloc] init];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  checkedImage = [UIImage imageNamed:@"contact_tick"];
  uncheckedImage = [UIImage imageNamed:@"tagFirend_unselected"];
  
  if (!selectedIDs) {
    selectedIDs = [[NSMutableArray alloc]init];
  }
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
- (void) loadFriendsList
{
  [LCAPIManager getFriendsForUser:[LCDataManager sharedDataManager].userID searchKey:nil lastUserId:nil withSuccess:^(id response) {
    friendsArray = response;
    [searchResultsArray addObjectsFromArray:response];
    [self.tableView reloadData];
  } andfailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
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

//- (void)checkbuttonAction :(UIButton *)sender
//{
//  selectedButton = sender;
//  LCFriend *friend = searchResultsArray[sender.tag];
//  [self AddOrRemoveID:friend.userID];
//}

//- (void)AddOrRemoveID :(id)ID_
//{
//  if ([selectedIDs containsObject:ID_])
//  {
//    [selectedIDs removeObject:ID_];
//    [selectedButton setImage:uncheckedImage forState:UIControlStateNormal];
//  }else
//  {
//    [selectedIDs addObject:ID_];
//    [selectedButton setImage:checkedImage forState:UIControlStateNormal];
//  }
//
//  NSLog(@"id----- > %@",selectedIDs);
//}

//- (void)setStatusForButton:(UIButton *)button byCheckingIDs:(NSArray *)IDs
//{
//  for (id ID_ in IDs)
//  {
//    if ([selectedIDs containsObject:ID_])
//    {
//      [button setImage:checkedImage forState:UIControlStateNormal];
//      return;
//    }
//  }
//  [button setImage:uncheckedImage forState:UIControlStateNormal];
//}


#pragma mark - searchfield delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  [searchResultsArray removeAllObjects];
  if([searchText length] != 0) {
    [self searchTableList:searchBar.text];
  }
  else
  {
    [searchResultsArray addObjectsFromArray:friendsArray];
  }
  [self.tableView reloadData];
}

- (void)searchTableList :(NSString *)text
{
  for (int i = 0; i<friendsArray.count ; i++)
  {
    LCFriend *friend = friendsArray[i];
    NSString * tempStr = [NSString stringWithFormat:@"%@ %@",friend.firstName, friend.lastName];
    NSComparisonResult result = [tempStr compare:text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [text length])];
    if (result == NSOrderedSame)
    {
      [searchResultsArray addObject:friend];
    }
  }
}

#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"LCInviteCommunityFriendCell";
  LCInviteCommunityFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCInviteCommunityFriendCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:MyIdentifier];
  }
  
  LCFriend *friend = searchResultsArray[indexPath.row];
  cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
  cell.friendPhotoView.layer.cornerRadius = cell.friendPhotoView.frame.size.width/2;
  [cell.friendPhotoView  sd_setImageWithURL:[NSURL URLWithString:friend.avatarURL] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  
  if ([selectedIDs containsObject:friend.friendId]) {
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [cell.checkButton setSelected:YES];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  LCInviteCommunityFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LCFriend *friend = searchResultsArray[indexPath.row];
  [selectedIDs addObject:friend.friendId];
  [cell.checkButton setSelected:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCInviteCommunityFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LCFriend *friend = searchResultsArray[indexPath.row];
  [selectedIDs removeObject:friend.friendId];
  [cell.checkButton setSelected:NO];
}
@end