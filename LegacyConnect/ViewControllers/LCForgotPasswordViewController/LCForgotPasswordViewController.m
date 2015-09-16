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
  UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 21)];
  [backButton setImage:[UIImage imageNamed:@"backButton_image"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [self.navigationItem setLeftBarButtonItem:backButtonItem];
  [self.emailTextField becomeFirstResponder];
}

- (void)backButtonPressed:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
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
  if ([LCUtilityManager validateEmail:_emailTextField.text])
  {
    [self.emailTextField resignFirstResponder];
    [self performPasswordResetRequestWithEmail:_emailTextField.text];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"invalid_mail_address", @"")];
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


@end
