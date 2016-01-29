//
//  LCReportPostViewController.m
//  LegacyConnect
//
//  Created by qbuser on 29/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCReportPostViewController.h"

@interface LCReportPostViewController ()

@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@end

#define kInfoBoldFont [UIFont fontWithName:@"Gotham-Bold" size:14.0f]
#define kInfoFont [UIFont fontWithName:@"Gotham-Book" size:14.0f]
#define kInfoItalixFont [UIFont fontWithName:@"Gotham-LightItalic" size:14.0f]
#define kInfoColor [UIColor colorWithRed:35/255.0 green:31/255.0  blue:32/255.0  alpha:1]
#define kInfoItalixColor [UIColor colorWithRed:134/255.0 green:134/255.0  blue:134/255.0  alpha:1]

@implementation LCReportPostViewController

#pragma mark - view lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self initialUISetUp];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
}

#pragma mark - private method implementation
- (void)initialUISetUp
{
  
  NSString * infoText = @"1. You are reporting this postdue to offensive content, objectionable content.\n\n2. This will be reporte to the ThatHelps admin for review.\n\n3. The admin shall approve or remove this post including but no limited to removing the user posting the flagged content from the Thathelps platform\n\nThe ThatHelps Admins have the final say on all content posted on the ThatHelps network";
  NSMutableAttributedString * info = [[NSMutableAttributedString alloc] initWithString:infoText];
  
  NSRange fullTxtRng = [infoText rangeOfString:infoText];
  [info addAttribute:NSFontAttributeName value:kInfoFont range:fullTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoColor range:fullTxtRng];

  NSRange boldTxtRag1 = [infoText rangeOfString:@"1."];
  [info addAttribute:NSFontAttributeName value:kInfoBoldFont range:boldTxtRag1];
  NSRange boldTxtRag2 = [infoText rangeOfString:@"2."];
  [info addAttribute:NSFontAttributeName value:kInfoBoldFont range:boldTxtRag2];
  NSRange boldTxtRag3 = [infoText rangeOfString:@"3."];
  [info addAttribute:NSFontAttributeName value:kInfoBoldFont range:boldTxtRag3];
  
  NSRange italixTxtRng = [infoText rangeOfString:@"The ThatHelps Admins have the final say on all content posted on the ThatHelps network"];
  [info addAttribute:NSFontAttributeName value:kInfoItalixFont range:italixTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoItalixColor range:italixTxtRng];

  [self.infoTextView setAttributedText:info];
  
  [self.reportButton.layer setCornerRadius:10.0f];
}

- (IBAction)cancelButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reportButtonTapped:(id)sender
{
  [LCPostAPIManager ReportPostWithPostId:self.postToReport.feedId withSuccess:^(id response) {
    [self dismissViewControllerAnimated:YES completion:nil];
  } andFailure:^(NSString *error) {
    
  }];
}

@end
