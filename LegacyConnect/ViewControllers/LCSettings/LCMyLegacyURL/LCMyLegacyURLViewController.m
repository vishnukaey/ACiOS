//
//  LCMyLegacyURL.m
//  LegacyConnect
//
//  Created by qbuser on 11/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCMyLegacyURLViewController.h"
#import "NSString+RemoveEmoji.h"

@interface LCMyLegacyURLViewController ()

@end

@implementation LCMyLegacyURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self initialUISetUp];
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialUISetUp
{
  
  [legacyURLTextField setText:_settingsData.legacyUrl];
  [legacyURLTextField becomeFirstResponder];
  
  [legacyURLLabel setText:[NSString stringWithFormat:@"%@%@",
                           kLegacyConnectUrl,
                           legacyURLTextField.text]];
  [saveButton setEnabled:NO];
}

#pragma mark - Action methods
- (IBAction)cancelAction:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveAction:(id)sender {
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCAPIManager changeLegacyURL:legacyURLTextField.text withSuccess:^(id response) {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    _settingsData.legacyUrl = legacyURLTextField.text;
    [self.delegate updateView];
    [self dismissViewControllerAnimated:YES completion:nil];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"error - %@",error);
  }];
}

-(IBAction)textFieldDidChange :(UITextField *)textField {
  
  if ([textField.text isIncludingEmoji]) {
    textField.text =[textField.text stringByRemovingEmoji];
  }
  
  legacyURLLabel.text = [NSString stringWithFormat:@"%@%@",kLegacyConnectUrl, legacyURLTextField.text];
  
  if ([LCUtilityManager isEmptyString:legacyURLTextField.text] || [legacyURLTextField.text isEqualToString:_settingsData.legacyUrl]) {
    [saveButton setEnabled:NO];
  }
  else {
    [saveButton setEnabled:YES];
  }
}

@end
