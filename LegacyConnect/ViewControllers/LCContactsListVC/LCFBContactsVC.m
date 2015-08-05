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
    [login logInWithReadPermissions:@[@"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
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

  H_friendsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y)];
  H_friendsTable.layer.borderColor = [UIColor greenColor].CGColor;
  H_friendsTable.layer.borderWidth = 3;
  H_friendsTable.delegate = self;
  H_friendsTable.dataSource = self;
}

-(void)getFacebookFriendsList
{
  //get the friends list
  NSDictionary *params1 = @{@"access_token": [[FBSDKAccessToken currentAccessToken] tokenString],@"fields": @"id,name,picture.type(large)"
  };

  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me/friends" parameters:params1 HTTPMethod:@"GET"];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
  {
    if (!error)
    {
      NSLog(@"fetched user:%@", result);
      H_friendsArray = [[NSMutableArray alloc] init];
      NSArray *friendsArray = [result objectForKey:@"data"];
      for (int i = 0; i<friendsArray.count; i++)
      {
        LCContact * con = [[LCContact alloc] init];
        con.P_name = [[friendsArray objectAtIndex:i] valueForKey:@"name"];
        NSURL *imageURL = [NSURL URLWithString:[[[[friendsArray objectAtIndex:i] objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];//image url;
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        con.P_image = image;
        [H_friendsArray addObject:con];
      }
      [self.view addSubview:H_friendsTable];
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
  return H_friendsArray.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }

  [[cell viewWithTag:10] removeFromSuperview];
  UIView *friendCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];

  UIImageView *friendImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
  LCContact *con = [H_friendsArray objectAtIndex:indexPath.row];
  friendImage.image = con.P_image;
  [friendCell addSubview:friendImage];

  UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, self.view.frame.size.width - 80, 20)];
  nameLabel.text = con.P_name;
  [friendCell addSubview:nameLabel];
  [cell addSubview:friendCell];
  friendCell.tag = 10;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
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
