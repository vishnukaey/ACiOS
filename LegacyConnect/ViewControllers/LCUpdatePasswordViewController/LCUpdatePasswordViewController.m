//
//  LCUpdatePasswordViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 15/07/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUpdatePasswordViewController.h"
#import "LCLoginViewController.h"

static NSString * kResetPasswordTitle = @"UPDATE PASSWORD";

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
  [self.updateButton.layer setCornerRadius:5];
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
    [self.updateButton setBackgroundColor:[LCUtilityManager getThemeRedColor]];
  }
  else
  {
    [self.updateButton setEnabled:false];
    [self.updateButton setBackgroundColor:[UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1.0]];
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
  if(![LCUtilityManager validatePassword:self.passwordTextField.text])
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"invalid_password", @"")];
  }
  else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"password_mismatch", @"")];
  }
  else
  {
    [LCAPIManager resetPasswordWithPasswordResetCode:self.token andNewPassword:_confirmPasswordTextField.text withSuccess:^(id response) {
      [_delegate updatePasswordSuccessful];
    } andFailure:^(NSString *error) {
      NSLog(@"error");
    }];
  }

}


@end
