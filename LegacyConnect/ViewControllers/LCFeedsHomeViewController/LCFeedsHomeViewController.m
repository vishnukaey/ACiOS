  //
//  LCFeedsHomeViewController.m
//  LegacyConnect
//
//  Created by qbuser on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsHomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LCFeedsHomeViewController ()

@end

@implementation LCFeedsHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)logout:(id)sender
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"logged_in"];
  [defaults synchronize];
  if ([FBSDKAccessToken currentAccessToken])
  {
    [[FBSDKLoginManager new] logOut];
  }
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
