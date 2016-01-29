//
//  LCTermsOfServiceViewController.m
//  LegacyConnect
//
//  Created by Kaey on 29/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCTermsOfServiceViewController.h"

@interface LCTermsOfServiceViewController ()

@end

@implementation LCTermsOfServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}



@end
