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
#import "LCNotificationsViewController.h"
#import "LCSocialShareManager.h"

static NSString *kTitle = @"MY FEED";

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

- (void)viewWillDisappear:(BOOL)animated
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:MFSideMenuStateNotificationEvent object:nil];
  [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self initialUISetUp];
  [LCDataManager sharedDataManager].userAvatarImage = [UIImage imageNamed:@"userProfilePic"];
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
         [LCUtilityManager saveUserDetailsToDataManagerFromResponse:responses];
         [self addSideMenuVIewController];
       } andFailure:^(NSString *error) {
         [self addSideMenuVIewController];
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

- (void)initialUISetUp
{
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:40.0f/255.0 green:40.0f/255.0 blue:40.0f/255.0 alpha:1.0]];
  [self.navigationController setNavigationBarHidden:NO];
  self.title = kTitle;
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void) addSideMenuVIewController
{
  [LCDataManager sharedDataManager].userToken = [[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey];
  
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  LCFeedsHomeViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];  //I have instantiated using storyboard id.
  navigationRoot = [[UINavigationController alloc] initWithRootViewController:centerViewController];
  
  LCLeftMenuController *leftSideMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLeftMenuVC"];
  leftSideMenuViewController.delegate_ = self;
  
  mainContainer = [MFSideMenuContainerViewController
                   containerWithCenterViewController:navigationRoot
                   leftMenuViewController:nil
                   rightMenuViewController:leftSideMenuViewController];
  mainContainer.rightMenuWidth = appdel.window.frame.size.width*3/4;
  appdel.window.rootViewController = mainContainer;
  [appdel.window makeKeyAndVisible];
  
  [self addGIButton];
  [self addMenuButton:navigationRoot];
  mainContainer.panMode = MFSideMenuPanModeNone;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuEventNotification:) name:MFSideMenuStateNotificationEvent object:nil];
}

- (void)menuEventNotification:(NSNotification*)notification
{
  //added to bring menu button to top on menu item selection.
  [navigationRoot.view bringSubviewToFront:menuButton];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)addGIButton
{
  //global impact button
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  giButton = [[LCGIButton alloc]initWithFrame:CGRectMake(appdel.window.frame.size.width - 76, appdel.window.frame.size.height - 76, 56, 56)];
  [mainContainer.view addSubview:giButton];
  [giButton setUpMenu];
  giButton.communityButton.tag = 0;
  [giButton.communityButton addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  appdel.GIButton = giButton;
  
  giButton.postPhotoButton.tag = 1;
  [giButton.postPhotoButton addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  
  giButton.postStatusButton.tag = 2;
  [giButton.postStatusButton addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  [giButton addTarget:self action:@selector(GIButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addMenuButton:(UIViewController*)vc
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  //menu poper button
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  
  menuButton = [[LCMenuButton alloc] initWithFrame:CGRectMake(appdel.window.frame.size.width - 50, statusBarViewRect.size.height, 50, self.navigationController.navigationBar.frame.size.height)];

  menuButton.backgroundColor = [UIColor clearColor];
  [vc.view addSubview:menuButton];
  [menuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
  appdel.menuButton = menuButton;
  menuButton.badgeLabel.text = @"2";
  
  UIImageView *icon_ = [[UIImageView alloc] initWithFrame:CGRectMake(10, menuButton.frame.size.height/2 - 12, 25, 25)];
  icon_.image = [UIImage imageNamed:@"MenuButton"];
  [menuButton addSubview:icon_];
//  [menuButton setBackgroundColor:[UIColor blueColor]];
}

#pragma mark - button actions
- (void)GIButtonClicked
{
  [mainContainer setMenuState:MFSideMenuStateClosed];
}

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
  LCDLog(@"tag-->>%d", (int)sender.tag);
  [mainContainer setMenuState:MFSideMenuStateClosed];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton toggle];
  
  if (sender.tag == 0)//create event
  {
//    [appdel.menuButton setHidden:YES];
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
    LCChooseCommunityInterest *vc = [sb instantiateViewControllerWithIdentifier:kChooseCommunityStoryBoardID];
    [navigationRoot pushViewController:vc animated:YES];
  }
  else if (sender.tag == 1)//photo post
  {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library", @"From Camera", nil];
    [sheet showInView:navigationRoot.view];
  }
  else if(sender.tag == 2)//text post
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
    createPostVC = [sb instantiateInitialViewController];
    
    createPostVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [navigationRoot presentViewController:createPostVC animated:YES completion:nil];
  }
  
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex < 2)
  {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    switch (buttonIndex)
    {
      case 0:
        type = UIImagePickerControllerSourceTypePhotoLibrary;
        break;
      case 1:
        type = UIImagePickerControllerSourceTypeCamera;
        break;
        
      default:
        break;
    }
    imagePicker.sourceType = type;
    imagePicker.delegate = self;
    [navigationRoot presentViewController:imagePicker animated:YES completion:^{ }];
  }
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:NULL];
  UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
  createPostVC = [sb instantiateInitialViewController];
  
  createPostVC.photoPostPhoto = chosenImage;
  createPostVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [navigationRoot presentViewController:createPostVC animated:YES completion:nil];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - leftmenu delegates
- (void)leftMenuItemSelectedAtIndex:(NSInteger)index
{
  [mainContainer setMenuState:MFSideMenuStateClosed];
  if (index == 0)//home
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
    LCFeedsHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (index == 1)//Interests
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
    LCFeedsHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
    
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
//    LCAllInterestVC *vc = [sb instantiateInitialViewController];
//    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (index == 2)//notifications
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
    LCFeedsHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
    
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kNotificationStoryBoardIdentifier bundle:nil];
//    LCNotificationsViewController *vc = [sb instantiateInitialViewController];
//    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (index == 3)//notifications
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
    LCFeedsHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  else if (index == 4)//logout
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
  else if (index == 5)//profile
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *vc = [sb instantiateInitialViewController];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = [LCDataManager sharedDataManager].userID;
    [navigationRoot setViewControllers:[NSArray arrayWithObject:vc]];
  }
  
  //added to bring menu button to top on menu item selection.
  [navigationRoot.view bringSubviewToFront:menuButton];
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
    [self leftMenuItemSelectedAtIndex:4];
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
