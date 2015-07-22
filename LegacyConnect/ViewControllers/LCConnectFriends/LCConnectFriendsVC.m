//
//  LCConnectFriendsVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCConnectFriendsVC.h"
#import "LCContactsListVC.h"


@interface LCConnectFriendsVC ()

@end

@implementation LCConnectFriendsVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(IBAction)buttonActions :(UIButton *)sender
{
  if (sender.tag == 1)//phone contacts
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];
    LCContactsListVC *next = [sb instantiateViewControllerWithIdentifier:@"ContactList"];
    [self.navigationController pushViewController:next animated:YES];
  }
  else if (sender.tag == 2)//facebook contacts
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];
    LCContactsListVC *next = [sb instantiateViewControllerWithIdentifier:@"FBContactList"];
    [self.navigationController pushViewController:next animated:YES];
  }
  else//not now -- tag is 3
  {
    //handle if user skips
  }
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
