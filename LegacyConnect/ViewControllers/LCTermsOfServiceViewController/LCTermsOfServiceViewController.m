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
  NSString *urlString = [NSString stringWithFormat:@"http://www.apple.com/legal/internet-services/itunes/in/terms.html"];
  [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
  
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
