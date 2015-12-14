//
//  LCLoginHomeViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LCLoginHomeViewController.h"
#import "LCWebServiceManager.h"
#import "LCConstants.h"

#import "LCConnectFriendsVC.h"

@interface LCLoginHomeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewYPosition;
@end

@implementation LCLoginHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (IS_IPHONE_4)
  {
    self.textViewYPosition.constant = -65.0f;
  } else if (IS_IPHONE_5)
  {
    self.textViewYPosition.constant = -45.0f;
  }
  // Cache data is removed completely during a new user sign-in.
  [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (IBAction)continueWithFBAction
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login logOut];
  [login logInWithReadPermissions:@[kEmailKey,@"public_profile",@"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    if (error)
    {
      NSLog(@"error %@",error);
    }
    else if (result.isCancelled)
    {
      NSLog(@"Cancelled");
    }
    else
    {
      if ([result.grantedPermissions containsObject:kEmailKey])
      {
        [self fetchUserDetailsFromFacebook];
      }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}


- (void) fetchUserDetailsFromFacebook
{
  if([FBSDKAccessToken currentAccessToken])
  {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id, email, name" forKey:kFieldsKey];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:kMeKey parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
       if (!error)
       {
         [self saveUserDetailsToDataManagerFromResponse:result];
         
         //save fb user id to NSUserDefaults
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSDictionary *response = result;
         [defaults setValue:response[kIDKey] forKey:kFBUserIDKey];
         
         NSArray *userDetailsArray = [self getFBUserDetailsArray:result];
         
         [LCOnboardingAPIManager performOnlineFBLoginRequest:userDetailsArray withSuccess:^(id response) {
           [self loginUser];
           [MBProgressHUD hideHUDForView:self.view animated:YES];
           
           /*
            Temporarily added alert, remove after sprint 1.
            */
//           [LCUtilityManager showAlertViewWithTitle:@"Success" andMessage:@"Login success!"];

         } andFailure:^(NSString *error) {
           NSLog(@"");
           [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
         
       }
     }];
  }
}



- (void)saveUserDetailsToDataManagerFromResponse:(id)response
{
  NSDictionary *userInfo = response;
  [LCDataManager sharedDataManager].userEmail = [LCUtilityManager performNullCheckAndSetValue:userInfo[kEmailKey]];
  [LCDataManager sharedDataManager].userFBID = [LCUtilityManager performNullCheckAndSetValue:userInfo[kIDKey]];
  [LCDataManager sharedDataManager].firstName = [LCUtilityManager performNullCheckAndSetValue:[FBSDKProfile currentProfile].firstName];
  [LCDataManager sharedDataManager].lastName = [LCUtilityManager performNullCheckAndSetValue:[FBSDKProfile currentProfile].lastName];
  [LCDataManager sharedDataManager].avatarUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[LCDataManager sharedDataManager].userFBID];
  [LCDataManager sharedDataManager].dob = [LCUtilityManager performNullCheckAndSetValue:userInfo[kDobKey]];
}


-(NSArray*) getFBUserDetailsArray:(id)response
{
  NSArray *userDetails = @[[LCDataManager sharedDataManager].userEmail,[LCDataManager sharedDataManager].firstName, [LCDataManager sharedDataManager].lastName, [LCDataManager sharedDataManager].dob, [LCDataManager sharedDataManager].userFBID, [FBSDKAccessToken currentAccessToken].tokenString, [LCDataManager sharedDataManager].avatarUrl];
  return userDetails;
}


- (void) loginUser
{
  [LCUtilityManager saveUserDefaultsForNewUser];
  [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)goToUpdatePassword:(NSNotification*)notification {
  
  NSDictionary *userInfo = notification.userInfo;
  
  NSMutableArray * viewArray = [[NSMutableArray alloc] initWithArray:[self.navigationController viewControllers]];
  LCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:kLoginStoryBoardID];
  [viewArray addObject:loginVC];
  LCUpdatePasswordViewController *updatePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:kUpdatePasswordStoryBoardID];
  updatePasswordVC.delegate = loginVC;
  updatePasswordVC.token = [userInfo objectForKey:kResetPasswordTokenKey];
  [viewArray addObject:updatePasswordVC];
  self.navigationController.viewControllers = viewArray;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


- (void)viewDidDisappear: (BOOL)animated
{
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)signInButtonClicked:(id)sender
{
//#if DEBUG
//  //testing community
//  [LCDataManager sharedDataManager].userToken = @"d3cc6a2b6ac3ef5100b31dbac2ab13e18e19589114da0165e06948a00181b5a3d5eca53c30f2da96a680e5bf709d0e64";
//  LCConnectFriendsVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"connectFriends"];
//  [self.navigationController pushViewController:loginVC animated:YES];
//  return;
//#endif
 
  
  LCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLoginViewController"];
  [self.navigationController pushViewController:loginVC animated:YES];
}

@end
