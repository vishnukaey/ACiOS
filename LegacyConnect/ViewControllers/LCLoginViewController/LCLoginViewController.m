//
//  LCLoginViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCLoginViewController.h"

@interface LCLoginViewController ()

@end

@implementation LCLoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:NO];
}


- (IBAction)loginButtonClicked:(id)sender
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"logged_in"];
  [defaults synchronize];
  [self.navigationController popToRootViewControllerAnimated:NO];
}


- (IBAction)forgotPasswordButtonClicked:(id)sender
{
  
}


@end
