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
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  selectedContacts = [[NSMutableArray alloc] init];
  [_friendsTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
  [self.navigationController setNavigationBarHidden:YES];
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
        [self.friendsTable reloadData];
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
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (finalFriendsArray.count == 0)
  {
    return 1;
  }
  return finalFriendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (finalFriendsArray.count == 0)
  {
    UITableViewCell *cell = [LCPaginationHelper getEmptyIndicationCellWithText:NSLocalizedString(@"no_facebook_friends_to_display", nil)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
  LCContact *con = [finalFriendsArray objectAtIndex:indexPath.row];
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
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 93;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCDLog(@"selected row-->>>%d", (int)indexPath.row);
  
  LCContact *con = [finalFriendsArray objectAtIndex:indexPath.row];
  LCFBContactsCell *cell = (LCFBContactsCell*)[_friendsTable cellForRowAtIndexPath:indexPath];
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
}

- (IBAction)doneButtonTapped:(id)sender
{
  [LCProfileAPIManager sendFriendRequestToFBFriends:selectedContacts withSuccess:^(id response) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  } andFailure:^(NSString *error) {
    LCDLog(@"%@",error);
  }];
}

@end
