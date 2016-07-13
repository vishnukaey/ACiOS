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
{
   NSString * forgotPaswordEmail;
}
@end

@implementation LCLoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateSignInButtonStatus];
  [_emailTextField addTarget:self
                      action:@selector(textFieldDidChange)
            forControlEvents:UIControlEventEditingChanged];
  [_passwordTextField addTarget:self
                         action:@selector(textFieldDidChange)
               forControlEvents:UIControlEventEditingChanged];
  self.navigationController.navigationBarHidden = true;
  
  //GATracking
  [LCGAManager ga_trackViewWithName:@"SignIn"];
 
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (forgotPaswordEmail.length) {
    [self showEmailSentAlert:forgotPaswordEmail];
  }
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
  [LCOnboardingAPIManager performLoginForUser:dict withSuccess:^(id response) {
    LCDLog(@"%@",response);
    NSError *error = nil;
    [LCUtilityManager clearWebCache];
    LCUserDetail *user = [MTLJSONAdapter modelOfClass:[LCUserDetail class] fromJSONDictionary:response[kResponseData] error:&error];
    [LCUtilityManager clearUserDefaultsForCurrentUser];
    [LCUtilityManager saveUserDetailsToDataManagerFromResponse:user];
    [LCUtilityManager saveUserDefaultsForNewUser];
    [loginBtn setEnabled:true];

    //GA Tracking
    [LCGAManager ga_trackEventWithCategory:@"SignIn" action:@"Success" andLabel:@"User Sign-in successful using email"];

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([response[@"data"][@"firstTimeLogin"] isEqualToString:@"1"])
    {
      [self performSegueWithIdentifier:@"loginOnboarding" sender:self];
      [LCTutorialManager resetTutorialPersistance];
    }
    else
    {
      [self.navigationController popToRootViewControllerAnimated:NO];
      [LCTutorialManager setTutorialPersistance];
    }
  } andFailure:^(NSString *error) {
    LCDLog(@"%@",error);
    [loginBtn setEnabled:true];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}


- (IBAction)forgotPasswordButtonClicked:(id)sender
{
  LCForgotPasswordViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:kForgotPasswordSID];
  forgotPasswordVC.delegate = self;
  [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}


- (void)forgotPasswordRequestSent:(NSString *)user
{
  forgotPaswordEmail = user;
  [self.navigationController popViewControllerAnimated:YES];
//  [self performSelector:@selector(showEmailSentAlert:) withObject:user afterDelay:1];
//  [self showEmailSentAlert:user];
}

-(void)showEmailSentAlert:(NSString*) user
{
    forgotPaswordEmail = kEmptyStringValue;
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


- (void)textFieldDidChange
{
  [self updateSignInButtonStatus];
}

-(void)updateSignInButtonStatus
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
