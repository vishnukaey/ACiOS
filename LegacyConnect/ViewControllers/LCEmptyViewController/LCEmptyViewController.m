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
#import "LCLoginViewController.h"
#import "LCAppLaunchHelper.h"

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
  [self addPasswordResetNotificationObserver];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Navigate to signup if user is NOT logged-in
  if(![[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatusKey])
  {
      UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
      UIViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
      [self.navigationController setNavigationBarHidden:YES];
      [self.navigationController pushViewController:myStoryBoardInitialViewController animated:NO];
    
    if ([LCAppLaunchHelper needsToShowPasswordResetScreen])
    {
      [self showPasswordResetScreen];
    }
  }
  else
  {
    //Fetch additional userdetails if user is logged-in
    if([[NSUserDefaults standardUserDefaults] valueForKey:kUserIDKey])
    {
      [LCAPIManager getUserDetailsOfUser:[[NSUserDefaults standardUserDefaults] valueForKey:kUserIDKey] WithSuccess:^(LCUserDetail *responses)
       {
         [LCDataManager sharedDataManager].userToken = [[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey];
         [LCUtilityManager saveUserDetailsToDataManagerFromResponse:responses];
         
         LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
         LCFeedsHomeViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];  //I have instantiated using storyboard id.
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
         
       } andFailure:^(NSString *error) {
         NSLog(@" error:  %@",error);
       }];
    }
    else
    {
      [LCUtilityManager clearUserDefaultsForCurrentUser];
      UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
      UIViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
      [self.navigationController setNavigationBarHidden:YES];
      [self.navigationController pushViewController:myStoryBoardInitialViewController animated:NO];
    }
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
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
    LCChooseCommunityInterest *vc = [sb instantiateViewControllerWithIdentifier:kChooseCommunityStoryBoardID];
    [navigationRoot pushViewController:vc animated:YES];
  }
  else if (sender.tag == 2)
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
    createPostVC = [sb instantiateInitialViewController];

    createPostVC.delegate = self;
    giButton.hidden = YES;
    menuButton.hidden = YES;
    CGRect frame = createPostVC.view.frame;
    frame.origin.y = 20;
    createPostVC.view.frame = frame;
    createPostVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [navigationRoot presentViewController:createPostVC animated:YES completion:nil];
  }
  else
  {
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
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 1)//profile
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *vc = [sb instantiateInitialViewController];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = [LCDataManager sharedDataManager].userID;
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 2)//Interests
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *vc = [sb instantiateInitialViewController];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (sender.tag == 3)//notifications
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kNotificationStoryBoardIdentifier bundle:nil];
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
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
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

#pragma mark - Passwor reset implementation
- (void)addPasswordResetNotificationObserver
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(showResetPasswordScreen:)
                                               name:kResetPasswordNotificationName
                                             object:nil];
}

- (void)removePasswordResetNotificationObserver
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kResetPasswordNotificationName
                                                object:nil];
}

- (void)showResetPasswordScreen:(NSNotification*)notification
{
  NSDictionary *userInfo = notification.userInfo;
  if ([self.navigationController.topViewController isKindOfClass:[LCLoginViewController class]]) {
    LCLoginViewController * loginViewController = (LCLoginViewController*)self.navigationController.topViewController;
    LCUpdatePasswordViewController *updatePasswordVC = [loginViewController.storyboard instantiateViewControllerWithIdentifier:kUpdatePasswordStoryBoardID];
    updatePasswordVC.delegate = loginViewController;
    updatePasswordVC.token = [userInfo objectForKey:kResetPasswordTokenKey];
    [self.navigationController pushViewController:updatePasswordVC animated:YES];
  }
  else
  {
    //Logout
    UIButton * dummyLogoutButton = [UIButton new];
    [dummyLogoutButton setTag:4];
    [self leftMenuButtonActions:dummyLogoutButton];
    [LCAppLaunchHelper setNeedsToShowPasswordResetScreenWithToken:[userInfo objectForKey:kResetPasswordTokenKey]];
  }
}


- (void)showPasswordResetScreen {
  // Set sign up story board
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  UIViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
  [self.navigationController setNavigationBarHidden:YES];
  [self.navigationController pushViewController:myStoryBoardInitialViewController animated:NO];
  
  NSMutableArray * viewArray = [[NSMutableArray alloc] initWithArray:[self.navigationController viewControllers]];
  LCLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:kLoginStoryBoardID];
  [viewArray addObject:loginVC];
  LCUpdatePasswordViewController *updatePasswordVC = [storyboard instantiateViewControllerWithIdentifier:kUpdatePasswordStoryBoardID];
  updatePasswordVC.delegate = loginVC;
  updatePasswordVC.token = [LCAppLaunchHelper getPasswordResetToken];
  [viewArray addObject:updatePasswordVC];
  [LCAppLaunchHelper clearPasswordResetToken];
  self.navigationController.viewControllers = viewArray;

}
@end
