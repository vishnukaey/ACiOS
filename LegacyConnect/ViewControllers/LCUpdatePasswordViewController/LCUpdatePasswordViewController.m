//
//  LCUpdatePasswordViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 15/07/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUpdatePasswordViewController.h"
#import "LCLoginViewController.h"
@interface LCUpdatePasswordViewController ()

@end

@implementation LCUpdatePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSString stringWithFormat:@""] forKey:@"typeOfLaunch"];
  [defaults synchronize];
  
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)updatePasswordButtonClicked:(id)sender
{
  
  if ([_confirmPasswordTextField.text isEqualToString:_passwordTextField.text])
  {
    _confirmPasswordTextField.isValid = YES;
    [_delegate updatePasswordSuccessful];
  }
  else
  {
    _confirmPasswordTextField.isValid = NO;
    
  }
}


- (IBAction)backButtonClicked:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}


@end
