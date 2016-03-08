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
#import "LCChooseActionsInterest.h"
#import "LCProfileViewVC.h"
#import "LCMyAndAllInterestVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LCLoginViewController.h"
#import "LCAppLaunchHelper.h"
#import "LCNotificationsViewController.h"
#import "LCSocialShareManager.h"
#import "LCSettingsViewController.h"
#import "UIImage+LCImageFix.h"
#import "LCFinalTutorialVC.h"
#import "LCLoginHomeViewController.h"


static NSString *kTitle = @"MY FEED";

@interface LCEmptyViewController ()
{
  LCCreatePostViewController *createPostVC;
  LCGIButton * giButton;
  LCMenuButton *menuButton;
  MFSideMenuContainerViewController *mainContainer;
  UINavigationController *navigationRoot;
  LCFinalTutorialVC *tutorialVC;
  id postEntityCopy;//to persist the value because it gets removed in the viewdiddissapear method of the interest/cause detail page when image picker is presented
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
  
  [LCDataManager sharedDataManager].userToken = [[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey];
  [LCDataManager sharedDataManager].userAvatarImage = [UIImage imageNamed:@"userProfilePic"];
  
  [self initialUISetUp];
  // Navigate to signup if user is NOT logged-in
  if(![[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatusKey])
  {
      UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
      UIViewController* initialVC = [storyboard instantiateInitialViewController];
      [self.navigationController setNavigationBarHidden:YES];
      [self.navigationController pushViewController:initialVC animated:NO];
    
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
      
      [LCUserProfileAPIManager getUserDetailsOfUser:[[NSUserDefaults standardUserDefaults] valueForKey:kUserIDKey] WithSuccess:^(LCUserDetail *responses)
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
      UIViewController* initialVC = [storyboard instantiateInitialViewController];
      [self.navigationController setNavigationBarHidden:YES];
      [self.navigationController pushViewController:initialVC animated:NO];
    }
  }
}

- (void)initialUISetUp
{
  [self.navigationController.navigationBar setBarTintColor:[LCNavigationBar getNavigationBarColor]];
  self.navigationController.navigationBar.translucent = NO;
  [self.navigationController setNavigationBarHidden:NO];
  self.title = kTitle;
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{NSForegroundColorAttributeName:[LCNavigationBar getTitleColor], NSFontAttributeName:[LCNavigationBar getTitleFont]}];
}



-(void) addSideMenuVIewController
{
  [LCDataManager sharedDataManager].userToken = [[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey];
  [LCDataManager sharedDataManager].userFBID = [[NSUserDefaults standardUserDefaults] valueForKey:kFBUserIDKey];
  
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  LCFeedsHomeViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];  //I have instantiated using storyboard id.
  navigationRoot = [[UINavigationController alloc] initWithRootViewController:centerViewController];
  [navigationRoot.interactivePopGestureRecognizer setDelegate:nil];
  LCLeftMenuController *leftSideMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLeftMenuVC"];
  leftSideMenuVC.delegate_ = self;
  
  mainContainer = [MFSideMenuContainerViewController
                   containerWithCenterViewController:navigationRoot
                   leftMenuViewController:nil
                   rightMenuViewController:leftSideMenuVC];
  mainContainer.rightMenuWidth = appdel.window.frame.size.width*3/4;
  appdel.window.rootViewController = mainContainer;
  appdel.mainContainer = mainContainer;
  
  [appdel.window makeKeyAndVisible];
  [self addGIButton];
  [self addMenuButton:navigationRoot];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuEventNotification) name:MFSideMenuStateNotificationEvent object:nil];
  [self presentTutorial];
}

- (void)presentTutorial
{
  NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
  if (![userdefaults boolForKey:kTutorialPresentKey]) {
    [userdefaults setBool:YES forKey:kTutorialPresentKey];
    LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard*  signupSB = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
    tutorialVC = [signupSB instantiateViewControllerWithIdentifier:@"Tutorial"];
    tutorialVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [appdel.window addSubview:tutorialVC.view];
  }
}

- (void)menuEventNotification
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

- (void)addMenuButton:(UIViewController*)controller
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  //menu poper button
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  
  menuButton = [[LCMenuButton alloc] initWithFrame:CGRectMake(appdel.window.frame.size.width - 50, statusBarViewRect.size.height, 50, self.navigationController.navigationBar.frame.size.height)];

  menuButton.backgroundColor = [UIColor clearColor];
  [controller.view addSubview:menuButton];
  [menuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
  appdel.menuButton = menuButton;
  [menuButton bringSubviewToFront:menuButton.badgeLabel];
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
    [self updateNotificationCount];
  }
  else
  {
    [mainContainer setMenuState:MFSideMenuStateClosed];
  }
  
}

- (void)GIBComponentsAction :(UIButton *)sender
{
  //GA Tracking
  [LCGAManager ga_trackEventWithCategory:@"Impacts" action:@"GI Button Tapped" andLabel:@"User initiated an Impact"];
  
  LCDLog(@"tag-->>%d", (int)sender.tag);
  [mainContainer setMenuState:MFSideMenuStateClosed];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton toggle];
  
  if (sender.tag == 0)//create event
  {
    [appdel.menuButton setHidden:YES];
    UIStoryboard*  actionsSB = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
    LCChooseActionsInterest *chooseInterestVC = [actionsSB instantiateViewControllerWithIdentifier:kChooseCommunityStoryBoardID];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:chooseInterestVC];
    [navigationRoot.interactivePopGestureRecognizer setDelegate:nil];
    [navigationRoot presentViewController:navC animated:YES completion:nil];
 
  }
  else if (sender.tag == 1)//photo post
  {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library", @"From Camera", nil];
    [sheet showInView:navigationRoot.view];
    postEntityCopy = appdel.currentPostEntity;
  }
  else if(sender.tag == 2)//text post
  {
    UIStoryboard*  createPostSB = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
    createPostVC = [createPostSB instantiateInitialViewController];
    if (appdel.currentPostEntity) {
      if ([appdel.currentPostEntity isKindOfClass:[LCInterest class]]) {
        createPostVC.selectedInterest = [appdel.currentPostEntity copy];
      }
      else if ([appdel.currentPostEntity isKindOfClass:[LCCause class]])
      {
        createPostVC.selectedCause = [appdel.currentPostEntity copy];
      }
    }
    
    createPostVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [navigationRoot presentViewController:createPostVC animated:YES completion:nil];
  }
  
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex < 2)
  {
    LCImagePickerController * imagePicker = [[LCImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
      type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 1)
    {
      type = UIImagePickerControllerSourceTypeCamera;
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
  UIImage *normalzedImage = [chosenImage normalizedImage];
  UIStoryboard*  createPostSB = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
  createPostVC = [createPostSB instantiateInitialViewController];
  
  createPostVC.photoPostPhoto = normalzedImage;
  if (postEntityCopy) {
    if ([postEntityCopy isKindOfClass:[LCInterest class]]) {
      createPostVC.selectedInterest = [postEntityCopy copy];
    }
    else if ([postEntityCopy isKindOfClass:[LCCause class]])
    {
      createPostVC.selectedCause = [postEntityCopy copy];
    }
    postEntityCopy = nil;
  }
  createPostVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [navigationRoot presentViewController:createPostVC animated:YES completion:nil];
  [LCUtilityManager setLCStatusBarStyle];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
  postEntityCopy = nil;
  [LCUtilityManager setLCStatusBarStyle];
}

#pragma mark - leftmenu delegates
- (void)leftMenuItemSelectedAtIndex:(NSInteger)index
{
  [mainContainer setMenuState:MFSideMenuStateClosed];
  if (index == 0)//home
  {
    UIStoryboard*  mainSB = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
    LCFeedsHomeViewController *feedsVC = [mainSB instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];
    [navigationRoot setViewControllers:@[feedsVC]];
  }
  else if (index == 1)//Interest
  {
    UIStoryboard*  interestSB = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
    LCMyAndAllInterestVC *interestVC = [interestSB instantiateViewControllerWithIdentifier:kAllAndMyInterestStoryBoardID];
    [navigationRoot setViewControllers:@[interestVC]];
  }
  else if (index == 2)//notifications
  {
    UIStoryboard*  notificationSB = [UIStoryboard storyboardWithName:kNotificationStoryBoardIdentifier bundle:nil];
    LCNotificationsViewController *notificationVC = [notificationSB instantiateInitialViewController];
    [navigationRoot setViewControllers:@[notificationVC]];
  }
  else if (index == 3)//settings
  {
    UIStoryboard*  settingsSB = [UIStoryboard storyboardWithName:kSettingsStoryBoardIdentifier bundle:nil];
    LCSettingsViewController *settingsVC = [settingsSB instantiateViewControllerWithIdentifier:kSettingsStoryBoardID];
    [navigationRoot setViewControllers:@[settingsVC]];
    
  }
  else if (index == 4)//profile
  {
    UIStoryboard*  profileSB = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileViewVC *profileVC = [profileSB instantiateInitialViewController];
    profileVC.userDetail = [[LCUserDetail alloc] init];
    profileVC.userDetail.userID = [LCDataManager sharedDataManager].userID;
    [navigationRoot setViewControllers:@[profileVC]];
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
  if(![[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatusKey] && self.navigationController)
  {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
    NSMutableArray *navigationArray = [[NSMutableArray alloc] init];
    NSArray *currentControllers = self.navigationController.viewControllers;
    [navigationArray addObject:currentControllers[0]];//adding current emptyviewController
    LCLoginHomeViewController *homeController = [storyboard instantiateViewControllerWithIdentifier:@"LoginHomeVC"];
    [navigationArray addObject:homeController];
    
    LCLoginViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"LCLoginViewController"];
    [navigationArray addObject:loginController];
    
    LCUpdatePasswordViewController *updatePasswordVC = [storyboard instantiateViewControllerWithIdentifier:kUpdatePasswordStoryBoardID];
    updatePasswordVC.token = userInfo[kResetPasswordTokenKey];
    //      UIViewController* initialVC = [storyboard instantiateInitialViewController];
    //
    //
    //    LCLoginViewController * loginViewController = (LCLoginViewController*)self.navigationController.topViewController;
    
    [navigationArray addObject:updatePasswordVC];
    
    self.navigationController.viewControllers = navigationArray;
  }
}


- (void)showPasswordResetScreen {
  // Set sign up story board
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  UIViewController* initialVC = [storyboard instantiateInitialViewController];
  [self.navigationController setNavigationBarHidden:YES];
  [self.navigationController pushViewController:initialVC animated:NO];
  
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

#pragma mark - Notification Update API call
/**
 * This is a temp place to implement the 'GetNotificationCount' API. Currently each time when right menu oppens, 
 * we call 'GetNotificationCount' API and update the notification count
 * in NavigationMenu. Later this API call implementation will be changed to appopriate location.
 */
- (void)updateNotificationCount
{
  LCDLog(@"Get Notification Count API call and Update");
  [LCNotificationsAPIManager getNotificationCountWithStatus:^(BOOL status) {
    [LCNotificationManager postNotificationCountUpdatedNotification];
  }];
}

@end
