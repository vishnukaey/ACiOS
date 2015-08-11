  //
//  LCEmptyViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCEmptyViewController.h"
#import "LCFeedsHomeViewController.h"
#import "LCFeedsCommentsController.h"
#import "MFSideMenu.h"
#import "LCGIButton.h"
#import "LCMenuButton.h"
#import "LCChooseCommunityInterest.h"
#import "LCProfileViewVC.h"
#import "LCAllInterestVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LCEmptyViewController ()
{
  MFSideMenuContainerViewController *H_container;
  UINavigationController *H_root;
}
@end

@implementation LCEmptyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [LCAPIManager getCausesForInterest:@"1" andLastCauseID:@"2" withSuccess:^(NSArray *responses) {
    NSLog(@"%@",responses);
  } andFailure:^(NSString *error) {
    NSLog(@"%@", error);
  }];
  // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Check if user is not logged in
  if(![[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatusKey])
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
    H_root = [[UINavigationController alloc] initWithRootViewController:centerViewController];

    LCLeftMenuController *leftSideMenuViewController = [[LCLeftMenuController alloc] init];
    leftSideMenuViewController.P_menuwidth = appdel.window.frame.size.width*2/3;
    leftSideMenuViewController.delegate_ = self;

    H_container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:H_root
                                                    leftMenuViewController:nil
                                                    rightMenuViewController:leftSideMenuViewController];
    H_container.rightMenuWidth = leftSideMenuViewController.P_menuwidth;
    appdel.window.rootViewController = H_container;
    [appdel.window makeKeyAndVisible];
    
    [self addfloatingButtons];
    H_container.panMode = MFSideMenuPanModeNone;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)addfloatingButtons
{
  //global impact button
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  LCGIButton * giButton = [[LCGIButton alloc]initWithFrame:CGRectMake(appdel.window.frame.size.width - 60, appdel.window.frame.size.height - 60, 50, 50)];
  [appdel.window addSubview:giButton];
  [giButton setUpMenu];
  giButton.P_community.tag = 0;
  [giButton.P_community addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  appdel.GIButton = giButton;
  [giButton setImage:[UIImage imageNamed:@"GIButton_dummy.png"] forState:UIControlStateNormal];
  
  giButton.P_video.tag = 1;
  [giButton.P_video addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  
  giButton.P_status.tag = 2;
  [giButton.P_status addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  
  //menu poper button
  LCMenuButton *menuButton = [[LCMenuButton alloc] initWithFrame:CGRectMake(appdel.window.frame.size.width - 40,30, 30, 30)];
  menuButton.layer.cornerRadius = menuButton.frame.size.width/2;
  menuButton.backgroundColor = [UIColor grayColor];
  [appdel.window addSubview:menuButton];
  [menuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
  appdel.menuButton = menuButton;
  [menuButton setImage:[UIImage imageNamed:@"menuButton_dummy.png"] forState:UIControlStateNormal];
  menuButton.badgeLabel.text = @"2";
}

#pragma mark - button actions
- (void)menuButtonAction
{
  if (H_container.menuState == MFSideMenuStateClosed) {
    [H_container setMenuState:MFSideMenuStateRightMenuOpen];
  }
  else
  {
    [H_container setMenuState:MFSideMenuStateClosed];
  }
  
}

- (void)GIBComponentsAction :(UIButton *)sender
{
  NSLog(@"tag-->>%d", (int)sender.tag);
  [H_container setMenuState:MFSideMenuStateClosed];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton toggle];
  [appdel.GIButton setHidden:YES];
  //  if (sender.tag == 2)
  //  {
  [appdel.menuButton setHidden:YES];
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCChooseCommunityInterest *vc = [sb instantiateViewControllerWithIdentifier:@"LCChooseCommunityInterest"];
  [H_root pushViewController:vc animated:YES];
  //  }
  //  else
  //  {
  //    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
  //    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
  //    [self.navigationController pushViewController:vc animated:YES];
  //  }
  
}

#pragma mark - leftmenu delegates
- (void)leftMenuButtonActions:(UIButton *)sender
{
  NSLog(@"left menu sender tag-->>%d", (int)sender.tag);
  [H_container setMenuState:MFSideMenuStateClosed];
  if (sender.tag == 0)//home
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeFeeds"];
    [H_root setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 1)//profile
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    [H_root setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 2)//Interests
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCAllInterestVC"];
    [H_root setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 3)//notifications
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Notification" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateInitialViewController];
    [H_root setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 4)//logout
  {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kLoginStatusKey];
    [defaults synchronize];
    [LCDataManager sharedDataManager].userToken = kEmptyStringValue;
    if ([FBSDKAccessToken currentAccessToken])
    {
      [[FBSDKLoginManager new] logOut];
    }
    LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
    appdel.window.rootViewController = myStoryBoardInitialViewController;
    [appdel.window makeKeyAndVisible];
  }
}


@end
