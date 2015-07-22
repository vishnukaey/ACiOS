//
//  LCLoginViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCLoginViewController.h"

@interface LCLoginViewController ()

@end

@implementation LCLoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:NO];
}


- (IBAction)loginButtonClicked:(id)sender
{
  [self performOnlineLoginRequest];
}

- (void)performOnlineLoginRequest
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[self.emailTextField.text,self.passwordTextField.text] forKeys:@[kEmailKey, kPasswordKey]];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kLoginURL];
  [webService performPostOperationWithUrl:url withParameters:dict withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
     }
     else
     {
       NSLog(@"%@",response);
       [self saveUserDetailsToDataManagerFromResponse:response];
       [self loginUser];
     }
     
   } andFailure:^(NSString *error) {
     NSLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
   }];
}


- (void)loginUser
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:kLoginStatusKey];
  [defaults synchronize];
  [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)saveUserDetailsToDataManagerFromResponse:(id)response
{
  NSDictionary *userInfo = response[kResponseData];
  [LCDataManager sharedDataManager].userEmail = userInfo[kEmailKey];
  [LCDataManager sharedDataManager].userID = userInfo[@"id"];
  [LCDataManager sharedDataManager].isActive = [userInfo[@"isActive"] boolValue];
  [LCDataManager sharedDataManager].userToken = [LCUtilityManager generateUserTokenForUserID:userInfo[@"id"] andPassword:self.passwordTextField.text];
}

- (IBAction)forgotPasswordButtonClicked:(id)sender
{
  
}


@end
