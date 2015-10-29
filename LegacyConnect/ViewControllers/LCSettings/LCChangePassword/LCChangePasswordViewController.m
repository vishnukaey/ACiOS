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

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@end

@implementation LCChangePasswordViewController

#pragma mark - private method implementation

- (void)changeSaveButtonState {
  if (self.passwordField.text.length > 0 && self.confirmPasswordField.text.length > 0)
  {
    [self.navigationItem.rightBarButtonItem setEnabled:true];
  }
  else
  {
    [self.navigationItem.rightBarButtonItem setEnabled:false];
  }
}

- (void)initialUISetUp
{
  self.navigationController.navigationBarHidden = false;
  self.title = kEmailUpdateScreenTitle;
  //self.confirmPasswordField.isValid = YES;
  UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                               target:self
                                                                               action:@selector(saveButtonPressed:)];
  [saveButton setTintColor:[UIColor blackColor]];
  self.navigationItem.rightBarButtonItem = saveButton;
  [saveButton setEnabled:false];
}

- (void)saveButtonPressed:(id)sender
{
  if ([self.passwordField.text isEqual:self.confirmPasswordField.text])
  {
    //self.confirmPasswordField.isValid = YES;
    [self.navigationController popViewControllerAnimated:YES];
  }
  else
  {
    //self.confirmPasswordField.isValid = NO;
  }
}


#pragma mark - view life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self changeSaveButtonState];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self changeSaveButtonState];
}

@end
