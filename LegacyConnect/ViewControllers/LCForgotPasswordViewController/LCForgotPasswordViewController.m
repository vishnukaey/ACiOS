//
//  LCForgotPasswordViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 15/07/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCForgotPasswordViewController.h"

@interface LCForgotPasswordViewController ()


@end

@implementation LCForgotPasswordViewController

#pragma mark - view lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:false];
  [self.emailTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.emailTextField resignFirstResponder];
  [super viewWillDisappear:animated];
}

#pragma mark - IBAction implementation

- (IBAction)submitButtonClicked:(id)sender
{
  if ([self validateEmail])
  {
    [self.emailTextField resignFirstResponder];
    [self performPasswordResetRequestWithEmail:_emailTextField.text];
  }
}

#pragma mark - private method implementation
- (void)performPasswordResetRequestWithEmail:(NSString*)email {
  
  [LCAPIManager forgotPasswordOfUserWithMailID:email withSuccess:^(id response) {
    [self.delegate forgotPasswordRequestSent:_emailTextField.text];
  } andFailure:^(NSString *error) {
    NSLog(@"response : %@",error);
  }];
}

- (BOOL)validateEmail
{
  _emailTextField.isValid = YES;
  NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  bool isvalid = [emailTest evaluateWithObject:_emailTextField.text];
  if(isvalid)
  {
    _emailTextField.isValid = YES;
    return YES;
  }
  else
  {
    [self showInvalidMailErrorMessage];
    _emailTextField.isValid = NO;
    return NO;
  }
}

- (void)showInvalidMailErrorMessage
{
  UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                       message:NSLocalizedString(@"invalid_mail_address", @"")
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"ok", @"")
                                             otherButtonTitles: nil];
  [errorAlert show];
}

#pragma mark - UIAlertViewDelegate implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self.emailTextField becomeFirstResponder];
}

@end
