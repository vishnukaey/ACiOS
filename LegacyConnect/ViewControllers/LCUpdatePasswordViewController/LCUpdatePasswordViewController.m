//
//  LCUpdatePasswordViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 15/07/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUpdatePasswordViewController.h"
#import "LCLoginViewController.h"
@interface LCUpdatePasswordViewController ()

@end

@implementation LCUpdatePasswordViewController

#pragma mark - view life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
//  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//  [defaults setObject:[NSString stringWithFormat:@""] forKey:@"typeOfLaunch"];
//  [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - IBAction implementation
- (IBAction)updatePasswordButtonClicked:(id)sender
{
  if ([_confirmPasswordTextField.text isEqualToString:_passwordTextField.text])
  {
    _confirmPasswordTextField.isValid = YES;
    [LCAPIManager resetPasswordWithPasswordResetCode:self.token andNewPassword:_confirmPasswordTextField.text withSuccess:^(id response) {
      [_delegate updatePasswordSuccessful];
    } andFailure:^(NSString *error) {
      NSLog(@"error");
    }];
  }
  else
  {
    _confirmPasswordTextField.isValid = NO;
  }
}

- (IBAction)backButtonClicked:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}


@end
