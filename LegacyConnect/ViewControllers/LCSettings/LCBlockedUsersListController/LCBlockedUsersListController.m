//
//  LCBlockedUsersListController.m
//  LegacyConnect
//
//  Created by qbuser on 30/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCBlockedUsersListController.h"
#import "LCBlockedUsersCell.h"

@interface LCBlockedUsersListController ()

@end

@implementation LCBlockedUsersListController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonTapped:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(id)sender
{
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCBlockedUsersCell * friendsCell = (LCBlockedUsersCell*)[tableView dequeueReusableCellWithIdentifier:@"LCBlockedUsersCell" forIndexPath:indexPath];
  if (friendsCell == nil) {
    friendsCell = [[LCBlockedUsersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LCBlockedUsersCell"];
  }
  friendsCell.userDetails = [self.results objectAtIndex:indexPath.row];
  return friendsCell;
}





@end
