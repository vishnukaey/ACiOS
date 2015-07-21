  //
//  LCEmptyViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCEmptyViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "LCFeedsHomeViewController.h"
#import "LCFeedsCommentsController.h"
#import "MFSideMenu.h"
#import "LCAppDelegate.h"

#import "leftMenuController.h"

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
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:myStoryBoardInitialViewController animated:NO];
  }
  else
  {
      //create appdelegate object to make the MFmenucontainer controller as the root view controller
      //add homefeed controller as the center controller and leftmenu controller as the left menu to the container controller.
      //make the homefeed controller as delegate of leftmenu
      LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
      
      LCFeedsHomeViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeFeeds"];  //I have instantiated using storyboard id.
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:centerViewController];
      
      leftMenuController *leftSideMenuViewController = [[leftMenuController alloc] init];
      leftSideMenuViewController.P_menuwidth = appdel.window.frame.size.width*2/3;
      leftSideMenuViewController.delegate_ = centerViewController;

      MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                      containerWithCenterViewController:nav
                                                      leftMenuViewController:leftSideMenuViewController
                                                      rightMenuViewController:nil];
      container.leftMenuWidth = leftSideMenuViewController.P_menuwidth;
      appdel.window.rootViewController = container;
      [appdel.window makeKeyAndVisible];
      

  }
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
