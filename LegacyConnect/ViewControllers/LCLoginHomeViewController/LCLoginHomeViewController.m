//
//  LCLoginHomeViewController.m
//  LegacyConnect
//
//  Created by qbuser on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LCLoginHomeViewController.h"

@interface LCLoginHomeViewController ()

@end

@implementation LCLoginHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
  CGRect frame = loginButton.frame;
  frame.origin.x = 0.0;
  frame.origin.y = 0.0;
  loginButton.frame = frame;
  [self.fbButtonContainer addSubview:loginButton];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
  if ([FBSDKAccessToken currentAccessToken])
  {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear: (BOOL)animated
{
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  [super viewDidDisappear:animated];
}

@end
