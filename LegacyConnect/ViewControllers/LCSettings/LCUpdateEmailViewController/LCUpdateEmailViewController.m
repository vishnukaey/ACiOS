//
//  LCUpdateEmailViewController.m
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUpdateEmailViewController.h"

@interface LCUpdateEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@end

@implementation LCUpdateEmailViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
  
  [super viewDidLoad];
  [self initialUISetUp];
}

- (void) viewWillDisappear:(BOOL)animated {
  
  [super viewWillDisappear:animated];
  [self.emailAddressField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - private method implementation

- (void)initialUISetUp
{
  self.navigationController.navigationBarHidden = false;
  
  [self.emailAddressField setText:self.emailAddress];
  [self.emailAddressField becomeFirstResponder];
  [self changeSaveButtonState];
}

- (void)changeSaveButtonState
{
  //[self.navigationItem.rightBarButtonItem setEnabled:(self.emailAddressField.text.length > 0)];
  if ([LCUtilityManager isEmptyString:self.emailAddressField.text]) {
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
  
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate implementation
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  [self changeSaveButtonState];
  return YES;
}
@end
