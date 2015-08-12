//
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
  LCCreatePostViewController *createPostVC;
  LCGIButton * giButton;
  LCMenuButton *menuButton;
  MFSideMenuContainerViewController *mainContainer;
  UINavigationController *navigationRoot;
}
@end

@implementation LCEmptyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

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
    
    [LCDataManager sharedDataManager].userToken = [[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey];
    LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    LCFeedsHomeViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeFeeds"];  //I have instantiated using storyboard id.
    navigationRoot = [[UINavigationController alloc] initWithRootViewController:centerViewController];

    LCLeftMenuController *leftSideMenuViewController = [[LCLeftMenuController alloc] init];
    leftSideMenuViewController.menuwidth = appdel.window.frame.size.width*2/3;
    leftSideMenuViewController.delegate_ = self;

    mainContainer = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navigationRoot
                                                    leftMenuViewController:nil
                                                    rightMenuViewController:leftSideMenuViewController];
    mainContainer.rightMenuWidth = leftSideMenuViewController.menuwidth;
    appdel.window.rootViewController = mainContainer;
    [appdel.window makeKeyAndVisible];
    
    [self addfloatingButtons];
    mainContainer.panMode = MFSideMenuPanModeNone;
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
  giButton = [[LCGIButton alloc]initWithFrame:CGRectMake(appdel.window.frame.size.width - 60, appdel.window.frame.size.height - 60, 50, 50)];
  [appdel.window addSubview:giButton];
  [giButton setUpMenu];
  giButton.communityButton.tag = 0;
  [giButton.communityButton addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  appdel.GIButton = giButton;
  [giButton setImage:[UIImage imageNamed:@"GIButton_dummy.png"] forState:UIControlStateNormal];
  
  giButton.postPhotoButton.tag = 1;
  [giButton.postPhotoButton addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  
  giButton.postStatusButton.tag = 2;
  [giButton.postStatusButton addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  
  //menu poper button
  menuButton = [[LCMenuButton alloc] initWithFrame:CGRectMake(appdel.window.frame.size.width - 40,30, 30, 30)];
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
  if (mainContainer.menuState == MFSideMenuStateClosed) {
    [mainContainer setMenuState:MFSideMenuStateRightMenuOpen];
  }
  else
  {
    [mainContainer setMenuState:MFSideMenuStateClosed];
  }
  
}

- (void)GIBComponentsAction :(UIButton *)sender
{
  NSLog(@"tag-->>%d", (int)sender.tag);
  [mainContainer setMenuState:MFSideMenuStateClosed];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton toggle];
  [appdel.GIButton setHidden:YES];
  if (sender.tag == 1)
  {
    [appdel.menuButton setHidden:YES];
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
    LCChooseCommunityInterest *vc = [sb instantiateViewControllerWithIdentifier:@"LCChooseCommunityInterest"];
    [navigationRoot pushViewController:vc animated:YES];
  }
  else if (sender.tag == 2)
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"CreatePost" bundle:nil];
    createPostVC = [sb instantiateViewControllerWithIdentifier:@"LCCreatePostViewController"];
    [createPostVC.view setFrame:CGRectMake(0, 20, 320, 300)];
    createPostVC.delegate = self;
    giButton.hidden = YES;
    menuButton.hidden = YES;
    [mainContainer.view addSubview:createPostVC.view];
    
    
  }
  else
  {
    //      UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    //      LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    //      [self.navigationController pushViewController:vc animated:YES];
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [view setBackgroundColor:[UIColor blackColor]];
    [mainContainer.view addSubview:view];
  }
  
}

#pragma mark - leftmenu delegates
- (void)leftMenuButtonActions:(UIButton *)sender
{
  NSLog(@"left menu sender tag-->>%d", (int)sender.tag);
  [mainContainer setMenuState:MFSideMenuStateClosed];
  if (sender.tag == 0)//home
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeFeeds"];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 1)//profile
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 2)//Interests
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCAllInterestVC"];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 3)//notifications
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Notification" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateInitialViewController];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 4)//logout
  {
    [LCUtilityManager clearUserDefaultsForCurrentUser];
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


- (void)dismissView
{
  giButton.hidden = NO;
  menuButton.hidden = NO;
}

@end
