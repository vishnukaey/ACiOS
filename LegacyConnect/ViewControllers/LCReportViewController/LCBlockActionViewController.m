//
//  LCBlockActionViewController.m
//  LegacyConnect
//
//  Created by qbuser on 30/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCBlockActionViewController.h"

@interface LCBlockActionViewController ()
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *blockButton;

@end

#define kInfoFont [UIFont fontWithName:@"Gotham-Book" size:14.0f]
#define kInfoItalixFont [UIFont fontWithName:@"Gotham-LightItalic" size:14.0f]
#define kInfoColor [UIColor colorWithRed:35/255.0 green:31/255.0  blue:32/255.0  alpha:1]
#define kInfoItalixColor [UIColor colorWithRed:134/255.0 green:134/255.0  blue:134/255.0  alpha:1]

@implementation LCBlockActionViewController

#pragma maek - View life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
}


#pragma mark - privete method implementation
- (void)initialUISetUp
{
  NSString * infoText = @"You are reporting this event because it may contain content that is offensive or objectionable.\n\nThis event will be reported to the ThatHelps admin for review.\n\nThe ThatHelps admin will either approve or remove this event. The event could be removed from ThatHelps if the content is deemed to be offensive or objectionable.\n\nThe Admins have the final say on all content and posts on the ThatHelps network";
  
  NSMutableAttributedString * info = [[NSMutableAttributedString alloc] initWithString:infoText];
  
  NSRange fullTxtRng = [infoText rangeOfString:infoText];
  [info addAttribute:NSFontAttributeName value:kInfoFont range:fullTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoColor range:fullTxtRng];
  
  NSRange italixTxtRng = [infoText rangeOfString:@"The Admins have the final say on all content and posts on the ThatHelps network"];
  [info addAttribute:NSFontAttributeName value:kInfoItalixFont range:italixTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoItalixColor range:italixTxtRng];
  
  [self.infoTextView setAttributedText:info];
  
  [self.blockButton.layer setCornerRadius:5.0f];

}

#pragma Button actions
- (IBAction)cancelButtonTapped:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)blockActionBtntapped:(id)sender
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  
  [LCEventAPImanager blockEventWithEvent:self.eventToBlock withSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  }];
}
@end
