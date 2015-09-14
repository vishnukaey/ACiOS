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
#import "MBProgressHud.h"

@interface LCLoginHomeViewController ()

@end

@implementation LCLoginHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (IBAction)continueWithFBAction
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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
      if ([result.grantedPermissions containsObject:@"email"])
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
    [parameters setValue:@"id, email, name" forKey:@"fields"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
       if (!error)
       {
         [self saveUserDetailsToDataManagerFromResponse:result];
         NSArray *userDetailsArray = [self getFBUserDetailsArray:result];
         [LCAPIManager performOnlineFBLoginRequest:userDetailsArray withSuccess:^(id response) {
           [self loginUser];
           [MBProgressHUD hideHUDForView:self.view animated:YES];
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
  [LCDataManager sharedDataManager].avatarUrl = [NSString stringWithFormat:@"//graph.facebook.com/%@/picture",[LCDataManager sharedDataManager].userFBID];
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
  LCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLoginViewController"];
  [viewArray addObject:loginVC];
  LCUpdatePasswordViewController *updatePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCUpdatePasswordViewController"];
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
  LCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLoginViewController"];
  [self.navigationController pushViewController:loginVC animated:YES];
}

@end
