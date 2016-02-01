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
  
  NSString * infoText = @"You are reporting this post because this content is offensive or objectionable.\n\nThis content will be reported to the ThatHelps admin for review. The ThatHelps admin will either approve or remove this post.\n\nThe user posting the content could be removed from ThatHelps if the content is deemed to be offensive or objectionable.\n\nThe ThatHelps Admins have the final say on all content posted on the ThatHelps network";
  NSMutableAttributedString * info = [[NSMutableAttributedString alloc] initWithString:infoText];
  
  NSRange fullTxtRng = [infoText rangeOfString:infoText];
  [info addAttribute:NSFontAttributeName value:kInfoFont range:fullTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoColor range:fullTxtRng];
  
  NSRange italixTxtRng = [infoText rangeOfString:@"The ThatHelps Admins have the final say on all content posted on the ThatHelps network"];
  [info addAttribute:NSFontAttributeName value:kInfoItalixFont range:italixTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoItalixColor range:italixTxtRng];

  [self.infoTextView setAttributedText:info];
  
  [self.reportButton.layer setCornerRadius:5.0f];
}

- (IBAction)cancelButtonTapped:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"block_details_screen_dismissed" object:nil];
  }];
}

- (IBAction)reportButtonTapped:(id)sender
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCPostAPIManager reportPostWithPostId:self.postToReport withSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];    
  }];
}

@end
