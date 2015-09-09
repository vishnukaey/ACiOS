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
  NSLog(@"viewDidLoad");
}


-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveTestNotification:)
                                               name:@"logged_in_facebook"
                                             object:nil];
//  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//  NSString *typeOfLaunch = [defaults objectForKey:@"typeOfLaunch"];
//  if ([typeOfLaunch isEqualToString:@"resetPassword"])
//  {
//    [self signInButtonClicked:nil];
//  }
  NSLog(@"viewWillAppear");

}

- (IBAction)continueWithFBAction
{
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login logInWithReadPermissions:@[@"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    if (error) {
      // Process error
      NSLog(@"error %@",error);
    } else if (result.isCancelled) {
      // Handle cancellations
      NSLog(@"Cancelled");
    } else {
      if ([result.grantedPermissions containsObject:@"email"]) {
        // Do work
        NSLog(@"%@",result);
        NSLog(@"Correct");
      }
    }
  }];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
  if ([[notification name] isEqualToString:@"logged_in_facebook"])
  {
    if([FBSDKAccessToken currentAccessToken])
    {
      NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
      [parameters setValue:@"id, email, name, friends" forKey:@"fields"];
      [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
       startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error)
         {
           [self saveUserDetailsToDataManagerFromResponse:result];
           [self performOnlineFBLoginRequest:[self getFBUserDetails:result]];
         }
      }];
    }
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


-(NSArray*) getFBUserDetails:(id)response
{
  NSArray *userDetails = @[[LCDataManager sharedDataManager].userEmail,[LCDataManager sharedDataManager].firstName, [LCDataManager sharedDataManager].lastName, [LCDataManager sharedDataManager].dob, [LCDataManager sharedDataManager].userFBID, [FBSDKAccessToken currentAccessToken].tokenString, [LCDataManager sharedDataManager].avatarUrl];
  return userDetails;
}


- (void)performOnlineFBLoginRequest:(NSArray*)parameters
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:parameters forKeys:@[kEmailKey,kFirstNameKey, kLastNameKey, kDobKey, kFBUserIDKey, kFBAccessTokenKey, kFBAvatarImageUrlKey]];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kFBLoginURL];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [webService performPostOperationWithUrl:url andAccessToken:kEmptyStringValue withParameters:dict withSuccess:^(id response)
   {
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
     }
     else
     {
       NSLog(@"%@",response);
       NSDictionary *responseData = response[kResponseData];
       [LCDataManager sharedDataManager].avatarUrl = responseData[kFBAvatarImageUrlKey];
       [LCDataManager sharedDataManager].userID = responseData[kUserIDKey];
       [LCDataManager sharedDataManager].userToken = responseData[kAccessTokenKey];
       [self loginUser];
     }
   } andFailure:^(NSString *error) {
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     NSLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
   }];
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
  NSLog(@"viewDidDisappear");

}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(goToUpdatePassword:)
                                               name:@"logged_in_from_URL"
                                             object:nil];
}



- (IBAction)signInButtonClicked:(id)sender
{
  LCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLoginViewController"];
//  updatePasswordVC.delegate = self;
  [self.navigationController pushViewController:loginVC animated:YES];
}

@end
