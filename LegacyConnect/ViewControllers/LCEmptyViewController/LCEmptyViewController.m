//
//  LCEmptyViewController.m
//  LegacyConnect
//
//  Created by qbuser on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCEmptyViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface LCEmptyViewController ()

@end

@implementation LCEmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Check if user is not logged in
  if(![[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in"] && ![FBSDKAccessToken currentAccessToken])
  {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];
    UIViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:myStoryBoardInitialViewController animated:NO];
  }
  else
  {
    [self performSegueWithIdentifier:@"showFeeds" sender:self];
  }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
