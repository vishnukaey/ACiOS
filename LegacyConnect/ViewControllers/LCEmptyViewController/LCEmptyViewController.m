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
         
         LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
         LCFeedsHomeViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];  //I have instantiated using storyboard id.
         navigationRoot = [[UINavigationController alloc] initWithRootViewController:centerViewController];
         
         LCLeftMenuController *leftSideMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLeftMenuVC"];
//         leftSideMenuViewController.menuwidth = appdel.window.frame.size.width*2/3;
         leftSideMenuViewController.delegate_ = self;
         
         mainContainer = [MFSideMenuContainerViewController
                          containerWithCenterViewController:navigationRoot
                          leftMenuViewController:nil
                          rightMenuViewController:leftSideMenuViewController];
//         mainContainer.rightMenuWidth = leftSideMenuViewController.menuwidth;
         mainContainer.rightMenuWidth = appdel.window.frame.size.width*3/4;
         appdel.window.rootViewController = mainContainer;
         [appdel.window makeKeyAndVisible];
         
         [self addGIButton];
         [self addMenuButton:navigationRoot];
         mainContainer.panMode = MFSideMenuPanModeNone;
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuEventNotification:) name:MFSideMenuStateNotificationEvent object:nil];
         
         
         
         
//**********************************************************************
         

//         [LCAPIManager getPostDetails:@"1d235923-70dc-11e5-bc20-5d366641d516" WithSuccess:^(LCFeed *responses) {
//           NSLog(@"getting post details success - %@",responses);
//         } andFailure:^(NSString *error) {
//           NSLog(@"getting post details error - %@",error);
//         }];
         
         
//         NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:
//                             @"", @"",
//                             [permissions allObjects], fbsdkdfl_ACFacebookPermissionsKey(),
//                             defaultAudience, fbsdkdfl_ACFacebookAudienceKey(), // must end on this key/value due to audience possibly being nil
//                             nil];
//
         
//         NSDictionary *tag1 = @{@"id":@"1",
//                               @"type":@"cause",
//                               @"text":@"cause name 1"
//                                };
//         NSDictionary *tag2 = @{@"id":@"2",
//                                @"type":@"cause",
//                                @"text":@"cause name 2"
//                                };
//         NSDictionary *dict = @{
//                                @"message":@"new post 111",
//                                @"entityType":@"",
//                                @"entityId":@"1",
//                                @"postTags":@[tag1,tag2],
//                                @"location":@"Kochi",
//                                @"isMilestone":@"1"
//         
//                                };
         
         UIImage *image = [UIImage imageNamed:@"profileFriend"];
         
         LCNewPost *newPost = [[LCNewPost alloc] init];
         newPost.message = @"new post 119";
         newPost.entityType = @"";
         newPost.entityID = @"1";
         newPost.location = @"Kochi";
         newPost.isMilestone = @"1";
         
         LCTag *tag1 = [[LCTag alloc] init];
         tag1.tagID = @"1";
         tag1.type = @"cause";
         tag1.text = @"my cause";
         
         LCTag *tag2 = [[LCTag alloc] init];
         tag2.tagID = @"2";
         tag2.type = @"cause";
         tag2.text = @"my cause 2";
         
         newPost.postTags = @[tag1,tag2];
         
         
         
         
         
         [LCAPIManager createNewPost:newPost image:nil withSuccess:^(id response) {
           NSLog(@"post creation success - %@",response);
         } andFailure:^(NSString *error) {
           NSLog(@"post creation failed - %@",error);
         }];  

         
         
         
         
         [LCAPIManager getHomeFeedsWithSuccess:^(NSArray *response) {
           NSLog(@"feeds - %@",response);
         } andFailure:^(NSString *error) {
           
         }];
//**********************************************************************
         
      
         
       } andFailure:^(NSString *error) {
         [self addSideMenuVIewController];
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
  
  menuButton = [[LCMenuButton alloc] initWithFrame:CGRectMake(appdel.window.frame.size.width - 65, statusBarViewRect.size.height, 65, self.navigationController.navigationBar.frame.size.height)];

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
  NSLog(@"tag-->>%d", (int)sender.tag);
  [mainContainer setMenuState:MFSideMenuStateClosed];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton toggle];
//  [appdel.GIButton setHidden:YES];
//  if (sender.tag == 1)
//  {
//    [appdel.menuButton setHidden:YES];
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
//    LCChooseCommunityInterest *vc = [sb instantiateViewControllerWithIdentifier:kChooseCommunityStoryBoardID];
//    [navigationRoot pushViewController:vc animated:YES];
//  }
//  else if (sender.tag == 2)
//  {
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
//    createPostVC = [sb instantiateInitialViewController];
//
//    createPostVC.delegate = self;
//    giButton.hidden = YES;
//    menuButton.hidden = YES;
//    CGRect frame = createPostVC.view.frame;
//    frame.origin.y = 20;
//    createPostVC.view.frame = frame;
//    createPostVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [navigationRoot presentViewController:createPostVC animated:YES completion:nil];
//  }
//  else
//  {
//    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    [view setBackgroundColor:[UIColor blackColor]];
//    [mainContainer.view addSubview:view];
//  }
  
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
