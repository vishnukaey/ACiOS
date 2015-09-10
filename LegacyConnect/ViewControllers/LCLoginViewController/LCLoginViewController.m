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


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
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
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[self.emailTextField.text,self.passwordTextField.text] forKeys:@[kEmailKey, kPasswordKey]];
  [LCAPIManager performLoginForUser:dict withSuccess:^(id response) {
    NSLog(@"%@",response);
    [LCUtilityManager saveUserDetailsToDataManagerFromResponse:response];
    [LCUtilityManager saveUserDefaultsForNewUser];
    [self.navigationController popToRootViewControllerAnimated:NO];
    } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
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
