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

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)backButtonClicked:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)submitButtonClicked:(id)sender
{
  
}

@end
