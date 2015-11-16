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

#pragma mark - private method implementation

- (void)changeSaveButtonState
{
  //[self.navigationItem.rightBarButtonItem setEnabled:(self.emailAddressField.text.length > 0)];
}
- (void)initialUISetUp
{
  //self.navigationController.navigationBarHidden = false;
  //self.title = kEmailUpdateScreenTitle;
//  UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
//                                                                               target:self
//                                                                               action:@selector(saveButtonPressed:)];
//  [saveButton setTintColor:[UIColor blackColor]];
//  self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)saveButtonPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - view life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self initialUISetUp];
  [self.emailAddressField setText:self.emailAddress];
  [self.emailAddressField becomeFirstResponder];
  [self changeSaveButtonState];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)cancelAction:(id)sender {
  
  [self.emailAddressField resignFirstResponder];
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveAction:(id)sender {
  
}


#pragma mark - UITextFieldDelegate implementation
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  [self changeSaveButtonState];
  return YES;
}
@end
