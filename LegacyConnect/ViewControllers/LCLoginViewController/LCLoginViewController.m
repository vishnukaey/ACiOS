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
  _loginButton.enabled = NO;
  [_emailTextField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
  [_passwordTextField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
  self.navigationController.navigationBarHidden = true;
  
  //GATracking
  [LCGAManager ga_trackViewWithName:@"SignIn"];
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:NO];
}


- (IBAction)loginButtonClicked:(id)sender
{
  [self performOnlineLoginRequest:(UIButton*)sender];
}


- (void)performOnlineLoginRequest:(UIButton*)loginBtn
{
  [self.view endEditing:YES];
  if(![LCUtilityManager validateEmail:_emailTextField.text])
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"invalid_mail_address", @"")];
    return;
  }

  [loginBtn setEnabled:false];
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[self.emailTextField.text,self.passwordTextField.text] forKeys:@[kEmailKey, kPasswordKey]];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCAPIManager performLoginForUser:dict withSuccess:^(id response) {
    NSLog(@"%@",response);
    [LCUtilityManager saveUserDetailsToDataManagerFromResponse:response];
    [LCUtilityManager saveUserDefaultsForNewUser];
    [loginBtn setEnabled:true];

    //GA Tracking
    [LCGAManager ga_trackEventWithCategory:@"SignIn" action:@"Success" andLabel:@"User Sign-in successful"];

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
    [loginBtn setEnabled:true];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}


- (IBAction)forgotPasswordButtonClicked:(id)sender
{
  LCForgotPasswordViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:kForgotPasswordStoryBoardID];
  forgotPasswordVC.delegate = self;
  [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}


- (void)forgotPasswordRequestSent:(NSString *)user
{
  [self.navigationController popViewControllerAnimated:YES];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"email_sent_message", @""),user] delegate:nil cancelButtonTitle:NSLocalizedString(@"dismiss_button_title", @"") otherButtonTitles:nil];
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
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"password_updated", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dismiss_button_title", @"") otherButtonTitles:nil];
  [alertView show];
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if([textField isEqual:_emailTextField])
  {
    [_passwordTextField becomeFirstResponder];
  }
  else
  {
    [self performOnlineLoginRequest:self.loginButton];
  }
  return YES;
}


- (void)textFieldDidChange:(id)sender
{
  if(_emailTextField.text.length!=0 && _passwordTextField.text.length!=0)
  {
    _loginButton.enabled = YES;
  }
  else
  {
    _loginButton.enabled = NO;
  }
}


@end
