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

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:NO];

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
        NSLog(@"permissionError-->>");
      } else if (result.isCancelled)
      {
        // Handle cancellations
      } else
      {
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if ([result.grantedPermissions containsObject:@"user_friends"])
        {
          // Do work
          NSLog(@"permission granted-->>");
          [self getFacebookFriendsList];
        }
      }
    }];
  }
}

-(void)getFacebookFriendsList
{
  //get the friends list
  NSDictionary *params1 = @{@"access_token": [[FBSDKAccessToken currentAccessToken] tokenString],@"fields": @"id,name,picture.type(large)"
  };
  finalFriendsArray = [[NSMutableArray alloc] init];
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me/friends" parameters:params1 HTTPMethod:@"GET"];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
  {
    if (!error)
    {
      NSLog(@"fetched user:%@", result);
      finalFriendsArray = [[NSMutableArray alloc] init];
      NSArray *friendsArray = [result objectForKey:@"data"];
      for (int i = 0; i<friendsArray.count; i++)
      {
        LCContact * con = [[LCContact alloc] init];
        con.P_name = [[friendsArray objectAtIndex:i] valueForKey:@"name"];
        con.P_imageURL = [[[[friendsArray objectAtIndex:i] objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        [finalFriendsArray addObject:con];
         [self.friendsTable reloadData];
      }
    }
    else
    {
      NSLog(@"error-->>>%@", error);
      // Handle the result
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
  return finalFriendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
  [cell.conatctPhotoView sd_setImageWithURL:[NSURL URLWithString:con.P_imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
  cell.contactNameLabel.text = con.P_name;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 93;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}


@end
