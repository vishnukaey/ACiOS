//
//  LCChangePasswordViewController.m
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChangePasswordViewController.h"
//#import "LCLoginTextField.h"

@interface LCChangePasswordViewController ()

@end

@implementation LCChangePasswordViewController


#pragma mark - view life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - private method implementation

- (void)initialUISetUp
{
  self.navigationController.navigationBarHidden = false;
  
  [newPasswordField becomeFirstResponder];
  [newPasswordField addTarget:self
                             action:@selector(validateFields)
                   forControlEvents:UIControlEventEditingChanged];
  [confirmPasswordField addTarget:self
                       action:@selector(validateFields)
             forControlEvents:UIControlEventEditingChanged];
  [saveButton setEnabled:NO];
}

- (void)validateFields
{
  if ([LCUtilityManager isEmptyString:newPasswordField.text] || [LCUtilityManager isEmptyString:confirmPasswordField.text]) {
    [saveButton setEnabled:NO];
  }
  else {
    [saveButton setEnabled:YES];
  }
}


#pragma mark - Action methods

- (IBAction)cancelAction:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveAction:(id)sender {
  
  if(![LCUtilityManager validatePassword:newPasswordField.text])
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"invalid_password", @"")];
  }
  else if (![newPasswordField.text isEqualToString:confirmPasswordField.text])
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"password_mismatch", @"")];
  }
  else
  {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [LCAPIManager changePassword:newPasswordField.text withSuccess:^(id response) {
      
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"password_changed", nil)];
      [self dismissViewControllerAnimated:YES completion:nil];
    } andFailure:^(NSString *error) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      NSLog(@"error - %@",error);
    }];

  }
}

@end
