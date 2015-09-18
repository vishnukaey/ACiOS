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
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

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
  [self changeUpdateButtonState];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self addTextFieldTextDidChangeNotifiaction];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self removeTextFieldTextDidChangeNotifiaction];
  [super viewWillDisappear:animated];
}


#pragma mark - private method implementation
- (void)addTextFieldTextDidChangeNotifiaction
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeUpdateButtonState)
                                               name:UITextFieldTextDidChangeNotification
                                             object:nil];
}

- (void)removeTextFieldTextDidChangeNotifiaction
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextFieldTextDidChangeNotification
                                                object:nil];
}

- (void)changeUpdateButtonState
{
  if (self.passwordTextField.text.length > 0 && self.confirmPasswordTextField.text.length > 0) {
    [self.updateButton setEnabled:true];
  }
  else
  {
    [self.updateButton setEnabled:false];
  }
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
