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
  self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
  self.imageView.clipsToBounds = YES;
  NSString *urlString = [NSString stringWithFormat:@"%@?type=normal",[LCDataManager sharedDataManager].avatarUrl];
  [_imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
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



@end
