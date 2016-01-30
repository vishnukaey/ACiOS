//
//  LCBlockUserViewController.m
//  LegacyConnect
//
//  Created by Akhil K C on 1/30/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCBlockUserViewController.h"

@interface LCBlockUserViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@end

#define kInfoBoldFont [UIFont fontWithName:@"Gotham-Bold" size:14.0f]
#define kInfoFont [UIFont fontWithName:@"Gotham-Book" size:14.0f]
#define kInfoColor [UIColor colorWithRed:35/255.0 green:31/255.0  blue:32/255.0  alpha:1]
#define kInfoItalixColor [UIColor colorWithRed:134/255.0 green:134/255.0  blue:134/255.0  alpha:1]

@implementation LCBlockUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self initialUISetUp];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
}

#pragma mark - private method implementation
- (void)initialUISetUp
{
  NSString * infoText = @"Blocking a user will result in hiding any content produced by the blocked user as well as adding them to a list of blocked users in the Settings section. This prevents them from seeing or searching your profile and posts within the ThatHelps network.";
  NSMutableAttributedString * info = [[NSMutableAttributedString alloc] initWithString:infoText];
  
  NSRange fullTxtRng = [infoText rangeOfString:infoText];
  [info addAttribute:NSFontAttributeName value:kInfoFont range:fullTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoColor range:fullTxtRng];
  
  [self.infoTextView setAttributedText:info];
  
  [self.reportButton.layer setCornerRadius:5.0f];
  [self.reportButton setTitle:[NSString stringWithFormat:@"Block %@",[LCUtilityManager performNullCheckAndSetValue:_userToBlock.firstName]] forState:UIControlStateNormal];
}

- (IBAction)cancelButtonTapped:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)blockButtonTapped:(id)sender
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCUserProfileAPIManager blockUserWithUserID:_userToBlock.userID withSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  }];
}

@end
