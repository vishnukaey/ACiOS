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
  [self addFBLoginbutton];
  NSLog(@"viewDidLoad");
}


-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveTestNotification:)
                                               name:@"logged_in_facebook"
                                             object:nil];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *typeOfLaunch = [defaults objectForKey:@"typeOfLaunch"];
  if ([typeOfLaunch isEqualToString:@"resetPassword"])
  {
    [self signInButtonClicked:nil];
  }
  NSLog(@"viewWillAppear");

}

- (void)addFBLoginbutton
{
  FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
  CGRect frame = loginButton.frame;
  frame.origin.x = 0.0;
  frame.origin.y = 0.0;
  loginButton.frame = frame;
  [self.fbButtonContainer addSubview:loginButton];
}


- (void) receiveTestNotification:(NSNotification *) notification
{
  if ([[notification name] isEqualToString:@"logged_in_facebook"])
  {
    if([FBSDKAccessToken currentAccessToken])
    {
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
      [parameters setValue:@"id, email, name" forKey:@"fields"];
      [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
       startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error)
         {
           [self saveUserDetailsToDataManagerFromResponse:result];
           [self performOnlineFBLoginRequest:[self getFBUserDetails]];
           [MBProgressHUD hideHUDForView:self.view animated:YES];
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
  [LCDataManager sharedDataManager].avatarUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",[LCDataManager sharedDataManager].userFBID];
  [LCDataManager sharedDataManager].dob = [LCUtilityManager performNullCheckAndSetValue:userInfo[kDobKey]];
}


-(NSArray*) getFBUserDetails
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
  [webService performPostOperationWithUrl:url withParameters:dict withSuccess:^(id response)
   {
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
     }
     else
     {
       NSLog(@"%@",response);
       [self loginUser];
     }
   } andFailure:^(NSString *error) {
     NSLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
   }];
}



- (void) loginUser
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:kLoginStatusKey];
  [defaults synchronize];
  [self.navigationController popToRootViewControllerAnimated:NO];
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


- (IBAction)signInButtonClicked:(id)sender
{
  LCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLoginViewController"];
//  updatePasswordVC.delegate = self;
  [self.navigationController pushViewController:loginVC animated:YES];
}

@end
