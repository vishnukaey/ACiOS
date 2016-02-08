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
  NSString *urlString = kToSURL;
  [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
  [MBProgressHUD showHUDAddedTo:self.webview animated:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [MBProgressHUD hideAllHUDsForView:self.webview animated:YES];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  [MBProgressHUD hideAllHUDsForView:self.webview animated:YES];
}


-(IBAction)cancelButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}



@end
