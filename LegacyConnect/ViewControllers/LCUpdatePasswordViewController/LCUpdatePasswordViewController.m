//
//  LCUpdatePasswordViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 15/07/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUpdatePasswordViewController.h"
#import "LCLoginViewController.h"

static NSString * kResetPasswordTitle = @"RESET PASSWORD";

@interface LCUpdatePasswordViewController ()

@end

@implementation LCUpdatePasswordViewController

#pragma mark - view life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:false];
  self.title = kResetPasswordTitle;
  UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 21)];
  [backButton setImage:[UIImage imageNamed:@"backButton_image"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [self.navigationItem setLeftBarButtonItem:backButtonItem];
}

- (void)backButtonPressed:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - IBAction implementation
- (IBAction)updatePasswordButtonClicked:(id)sender
{
  if ([_confirmPasswordTextField.text isEqualToString:_passwordTextField.text])
  {
    [LCAPIManager resetPasswordWithPasswordResetCode:self.token andNewPassword:_confirmPasswordTextField.text withSuccess:^(id response) {
      [_delegate updatePasswordSuccessful];
    } andFailure:^(NSString *error) {
      NSLog(@"error");
    }];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"password mistach"];
  }
}


@end
