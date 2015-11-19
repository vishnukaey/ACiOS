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
  [self.emailAddressField addTarget:self
                    action:@selector(validateFields)
          forControlEvents:UIControlEventEditingChanged];
  [saveButton setEnabled:NO];
}

- (void)validateFields
{
  if ([LCUtilityManager isEmptyString:self.emailAddressField.text] || [self.emailAddressField.text isEqualToString:self.emailAddress]) {
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
  if(![LCUtilityManager validateEmail:self.emailAddressField.text]) {
    
    [LCUtilityManager showAlertViewWithTitle:nil
                                  andMessage:NSLocalizedString(@"invalid_mail_address", @"")];
  }
  else {
    
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

@end
