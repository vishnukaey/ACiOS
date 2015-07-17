  //
//  LCSignupViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSignupViewController.h"

@interface LCSignupViewController ()

@end

@implementation LCSignupViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
   user = [[LCUser alloc] init];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonTapped:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:NO];
}


- (IBAction)nextButtonTapped:(id)sender
{
  if(![self validateFields])
  {
    [self performSegueWithIdentifier:@"selectPhoto" sender:self];
  }
}


- (BOOL)validateFields
{
  if([self fieldsNotMissing])
  {
    if([self validateEmail])
    {
      if([self validatePasswords])
      {
        return YES;
      }
    }
  }
  return NO;
}


- (BOOL)fieldsNotMissing
{
  [self clearWarnings];
  bool isValid = YES;
  if([_firstNameTextField.text isEqualToString:kEmptyStringValue])
  {
    _firstNameTextField.isValid = NO;
    isValid = NO;
  }
  if([_lastNameTextField.text isEqualToString:kEmptyStringValue])
  {
    _lastNameTextField.isValid = NO;
    isValid = NO;
  }
  if([_emailTextField.text isEqualToString:kEmptyStringValue])
  {
    _emailTextField.isValid = NO;
    isValid = NO;
  }
  if([_passwordTextField.text isEqualToString:kEmptyStringValue] || [_confirmPasswordTextField.text isEqualToString:kEmptyStringValue])
  {
    _passwordTextField.isValid = NO;
    isValid = NO;
  }
  if(!isValid)
  {
    _warningLabel.text = @"Missing Fields";
  }
  return isValid;
}


- (BOOL)validateEmail
{
  [self clearWarnings];
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
    _emailTextField.isValid = NO;
    _warningLabel.text = @"Invalid Email";
    return NO;
  }
}


- (BOOL)validatePasswords
{
  [self clearWarnings];
  if([_passwordTextField.text isEqualToString:_confirmPasswordTextField.text])
  {
    _confirmPasswordTextField.isValid=YES;
    return YES;
  }
  else
  {
    _warningLabel.text = @"Password Mismatch";
    _confirmPasswordTextField.isValid = NO;
    return NO;
  }
}

-(void)clearWarnings
{
  _warningLabel.text=@"";
  _firstNameTextField.isValid = YES;
  _lastNameTextField.isValid = YES;
  _emailTextField.isValid = YES;
  _passwordTextField.isValid = YES;
  _confirmPasswordTextField.isValid = YES;
}
@end
