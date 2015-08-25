//
//  LCInviteToCommunity.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCInviteToCommunity.h"
#import "LCViewCommunity.h"



#pragma mark - LCInviteCommunityFriendCell class
@interface LCInviteCommunityFriendCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *friendNameLabel;
@property(nonatomic, strong)IBOutlet UIImageView *friendPhotoView;
@property(nonatomic, strong)IBOutlet UIButton *checkButton;
@end

@implementation LCInviteCommunityFriendCell
@end

#pragma mark - LCInviteToCommunity class

@implementation LCInviteToCommunity
@synthesize eventToInvite;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  NSLog(@"event-->>%@", eventToInvite);
  [self loadFriendsList];
  searchResultsArray = [[NSMutableArray alloc] init];
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
  [LCAPIManager getFriendsWithSuccess:^(id response) {
    NSLog(@"%@",response);
    friendsArray = response;
    [searchResultsArray addObjectsFromArray:response];
    [friendsTableView reloadData];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
}


#pragma mark - button actions
-(IBAction)doneButtonAction
{
  NSLog(@"friendsTableView.selectedIDs-->>>%@", friendsTableView.selectedIDs);
  [LCAPIManager addUsersWithUserIDs:friendsTableView.selectedIDs forEventWithEventID:self.eventToInvite.eventID withSuccess:^(id response){
    NSLog(@"%@",response);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
    LCViewCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCViewCommunity"];
    [self.navigationController pushViewController:vc animated:YES];
  }andFailure:^(NSString *error){
    NSLog(@"%@",error);
  }];
}

- (IBAction)cancelAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkbuttonAction :(UIButton *)sender
{
  friendsTableView.selectedButton = sender;
  LCFriend *friend = searchResultsArray[sender.tag];
  [friendsTableView AddOrRemoveID:friend.userID];
}
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
  [friendsTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  NSLog(@"Search Clicked");
  [self searchTableList:searchBar.text];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return searchResultsArray.count;
}

- (UITableViewCell *)tableView:(LCMultipleSelectionTable *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
  [cell.friendPhotoView  sd_setImageWithURL:[NSURL URLWithString:friend.avatarURL] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  [cell.checkButton addTarget:self action:@selector(checkbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
  cell.checkButton.tag = indexPath.row;
  [tableView setStatusForButton:cell.checkButton byCheckingIDs:[NSArray arrayWithObjects:friend.userID, nil]];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
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
