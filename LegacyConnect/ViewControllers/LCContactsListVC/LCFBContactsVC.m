 //
//  LCFBContactsVC.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFBContactsVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LCContact.h"

#pragma mark - LCInviteFromContactsCell class
@interface LCFBContactsCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *contactLocationLabel;
@property(nonatomic, strong)IBOutlet UILabel *contactNameLabel;
@property(nonatomic, strong)IBOutlet UIImageView *conatctPhotoView;
@property(nonatomic, strong)IBOutlet UIButton *checkButton;
@end

@implementation LCFBContactsCell
@end


@implementation LCFBContactsVC
{
  NSMutableArray *selectedContacts;
    NSArray *sectionTitles;
    NSMutableDictionary *contactsDictionary;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  selectedContacts = [[NSMutableArray alloc] init];
  [_friendsTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
  [self.navigationController setNavigationBarHidden:YES];
  _friendsTable.sectionIndexColor = [UIColor blackColor];


  //request permission for accessing the friends list of the user. No need to ask permission everytime. Should store the status once the permission is granted and avoid this step from next access
  if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"])
  {
    [self getFacebookFriendsList];
  }
  else
  {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
      if (error)
      {
        // Process error
        LCDLog(@"permissionError-->>");
      } else if (result.isCancelled)
      {
        // Handle cancellations
        LCDLog(@"cancelled FB login-->>");
      } else
      {
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if ([result.grantedPermissions containsObject:@"user_friends"])
        {
          // Do work
          LCDLog(@"permission granted-->>");
          [self getFacebookFriendsList];
        }
      }
    }];
  }
}


-(void)getFacebookFriendsList
{
  [MBProgressHUD showHUDAddedTo:_friendsTable animated:YES];
  //get the friends list
  NSDictionary *params1 = @{@"access_token": [[FBSDKAccessToken currentAccessToken] tokenString],@"fields": @"id,name,picture.type(large)"
  };
  finalFriendsArray = [[NSMutableArray alloc] init];
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me/friends" parameters:params1 HTTPMethod:@"GET"];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
  {
    if (error)
    {
      LCDLog(@"error-->>>%@", error);
      [MBProgressHUD hideHUDForView:_friendsTable animated:YES];
    }
    else
    {
      LCDLog(@"fetched user:%@", result);
      finalFriendsArray = [[NSMutableArray alloc] init];
      NSArray *friendsArray = [result objectForKey:@"data"];
      for (int i = 0; i<friendsArray.count; i++)
      {
        LCContact * con = [[LCContact alloc] init];
        con.P_name = [friendsArray[i] valueForKey:@"name"];
        con.P_id = [friendsArray[i] valueForKey:@"id"];
        con.P_imageURL = [[[friendsArray[i] objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        [finalFriendsArray addObject:con];
        [self.fbFriendsCount setText:[NSString stringWithFormat:@"%lu friends using ThatHelps",(unsigned long)finalFriendsArray.count]];
        [self refreshTable];
      }
      [MBProgressHUD hideHUDForView:_friendsTable animated:YES];
    }
  }];

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [sectionTitles count];    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (finalFriendsArray.count == 0)
  {
    return 1;
  }
  return [[contactsDictionary valueForKey:[sectionTitles objectAtIndex:section]] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (finalFriendsArray.count == 0)
  {
    UITableViewCell *cell = [LCPaginationHelper getEmptyIndicationCellWithText:NSLocalizedString(@"no_facebook_friends_to_display", nil)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.allowsSelection = NO;
    return cell;
  }

  static NSString *MyIdentifier = @"LCFBContactsCell";
  LCFBContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCFBContactsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
  }
  LCContact *con = [[contactsDictionary valueForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
  cell.conatctPhotoView.layer.cornerRadius = cell.conatctPhotoView.frame.size.width/2;
  cell.conatctPhotoView.clipsToBounds = YES;
  [cell.conatctPhotoView sd_setImageWithURL:[NSURL URLWithString:con.P_imageURL] placeholderImage:nil];
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  cell.contactNameLabel.text = con.P_name;
  if([selectedContacts containsObject:con.P_id])
  {
    [cell.checkButton setSelected:YES];
  }
  else
  {
    [cell.checkButton setSelected:NO];
  }
  cell.checkButton.tag = indexPath.section*10+indexPath.row;
  [cell.checkButton addTarget:self action:@selector(checkbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  LCFBContactsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LCContact *con = [[contactsDictionary valueForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
  if([selectedContacts containsObject:con.P_id])
  {
    [cell.checkButton setSelected:NO];
    [selectedContacts removeObject:con.P_id];
  }
  else
  {
    [cell.checkButton setSelected:YES];
    [selectedContacts addObject:con.P_id];
  }
  [self updateRightBarButton];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 94;
}


- (void)checkbuttonAction:(UIButton *)sender
{
}


- (IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonTapped:(id)sender
{
  [LCProfileAPIManager sendFriendRequestToFBFriends:selectedContacts withSuccess:^(id response) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  } andFailure:^(NSString *error) {
    LCDLog(@"%@",error);
  }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  
  return [sectionTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.0;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
  return sectionTitles;
}

-(void)updateRightBarButton
{
  if(selectedContacts.count)
  {
    _doneButton.enabled = YES;
  }
  else
  {
    _doneButton.enabled = NO;
  }
}


-(void)refreshTable
{
  contactsDictionary = [self createDictionaryForSectionIndex:finalFriendsArray];
  sectionTitles = [[contactsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
  [_friendsTable reloadData];
}



-(NSMutableDictionary*)createDictionaryForSectionIndex:(NSArray*)array
{
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
  {
    NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
    NSArray *content = [finalFriendsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.P_name beginswith[cd] %@", firstCharacter]];
    NSMutableArray *mutableContent = [[NSMutableArray alloc]initWithArray:content];
    
    if ([mutableContent count] > 0)
    {
      NSString *key = [firstCharacter uppercaseString];
      [dict setObject:[mutableContent mutableCopy] forKey:key];
    }
  }
  return dict;
}


@end
