//
//  LCLoginViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCLoginViewController.h"
#import <SDWebImage/SDImageCache.h>

@interface LCLoginViewController ()

@end

@implementation LCLoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(goToUpdatePassword:)
                                               name:@"logged_in_from_URL"
                                             object:nil];
}


-(void)goToUpdatePassword:(id)sender
{
  LCUpdatePasswordViewController *updatePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCUpdatePasswordViewController"];
  updatePasswordVC.delegate = self;
  [self.navigationController pushViewController:updatePasswordVC animated:YES];
  
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
  [LCDataManager sharedDataManager].userID = userInfo[kIDKey];
  [LCDataManager sharedDataManager].firstName = userInfo[kFirstNameKey];
  [LCDataManager sharedDataManager].lastName = userInfo[kLastNameKey];
  [LCDataManager sharedDataManager].dob = userInfo[kDobKey];
  [LCDataManager sharedDataManager].avatarUrl = userInfo[kFBAvatarImageUrlKey];
  [LCDataManager sharedDataManager].userToken = [LCUtilityManager generateUserTokenForUserID:userInfo[kIDKey] andPassword:self.passwordTextField.text];
}

- (IBAction)forgotPasswordButtonClicked:(id)sender
{
  LCForgotPasswordViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCForgotPasswordViewController"];
  forgotPasswordVC.delegate = self;
  [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}


- (void)forgotPasswordRequestSent:(NSString *)user
{
  [self.navigationController popViewControllerAnimated:YES];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"An email has been sent to %@",user] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
  [alertView show];
}


- (void)updatePasswordSuccessful
{
  for(UIViewController * vc in self.navigationController.viewControllers)
  {
    if ([vc isKindOfClass:[LCLoginViewController class]])
    {
      [self.navigationController popToViewController:vc animated:YES];
    }
  }
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Your password has been successfully updated" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
  [alertView show];
  
}
@end
