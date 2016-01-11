//
//  WebViewVC.m
//  STTwitterDemoIOS
//
//  Created by Nicolas Seriot on 06/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "LCTWWebViewVC.h"

@interface LCTWWebViewVC ()

@end

@implementation LCTWWebViewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
      LCDLog(@"LCTWWebViewVC : Custom initialization");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
  self.webView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
  [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
  
    [self dismissViewControllerAnimated:YES completion:^{
        //
      [self.delegate webViewCancelledTwitterAuth];
    }];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
