//
//  LCAcceptTermsViewController.m
//  LegacyConnect
//
//  Created by Kaey on 29/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCAcceptTermsViewController.h"
#import "LCTermsOfServiceViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LCAcceptTermsViewController ()

@end

#define kInfoBoldFont [UIFont fontWithName:@"Gotham-Bold" size:13.0f]
#define kInfoFont [UIFont fontWithName:@"Gotham-Book" size:13.0f]
#define kInfoColor [UIColor colorWithRed:35/255.0 green:31/255.0  blue:32/255.0  alpha:1]

@implementation LCAcceptTermsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  
  // Do any additional setup after loading the view.
}


- (void)initialUISetUp
{
  _acceptTermsButton.layer.cornerRadius = 5.0;
  _readTermsButton.layer.cornerRadius = 5.0;
  
  NSString *infoText = @"By signing up you agree to these Terms of Service";
  NSMutableAttributedString * info = [[NSMutableAttributedString alloc] initWithString:infoText];
  
  NSRange fullTxtRng = [infoText rangeOfString:infoText];
  [info addAttribute:NSFontAttributeName value:kInfoFont range:fullTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoColor range:fullTxtRng];
  
  NSRange boldTxtRag1 = [infoText rangeOfString:@"Terms of Service"];
  [info addAttribute:NSFontAttributeName value:kInfoBoldFont range:boldTxtRag1];
  
  NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
  NSDictionary *tagsDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithRange:boldTxtRag1],@"range", nil];
  [tagsArray addObject:tagsDict];
  _termsLabel.tagsArray = tagsArray;
  _termsLabel.nameTagTapped = ^(int index)
  {
    [self readTermsofService:(_readTermsButton)];
  };
  [self.termsLabel setAttributedText:info];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(IBAction)declineTermsofService:(id)sender
{
  [LCUtilityManager clearUserDefaultsForCurrentUser];
  [self.navigationController popToRootViewControllerAnimated:YES];
}


-(IBAction)readTermsofService:(id)sender
{
  UIStoryboard *signSB = [UIStoryboard storyboardWithName:kSignupSID bundle:nil];
  LCTermsOfServiceViewController *termsVC = [signSB instantiateViewControllerWithIdentifier:@"LCTermsOfServiceViewController"];
  [self.navigationController pushViewController:termsVC animated:YES];
}


-(IBAction)acceptTermsofService:(id)sender
{
  NSArray *userDetailsArray = [self getFBUserDetailsArray];
  [LCOnboardingAPIManager performOnlineFBLoginRequest:userDetailsArray withSuccess:^(id response) {
    [LCGAManager ga_trackEventWithCategory:@"Registration" action:@"Success" andLabel:@"New User Registration Successful using FB"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loginUser:response];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}


-(NSArray*) getFBUserDetailsArray
{
  NSArray *userDetails = @[[LCDataManager sharedDataManager].userEmail,[LCDataManager sharedDataManager].firstName, [LCDataManager sharedDataManager].lastName, [LCDataManager sharedDataManager].dob, [LCDataManager sharedDataManager].userFBID, [FBSDKAccessToken currentAccessToken].tokenString, [LCDataManager sharedDataManager].avatarUrl];
  return userDetails;
}


- (void) loginUser:(id)response
{
  [self saveUserDetailsToDataManager:response];
  [LCUtilityManager saveUserDefaultsForNewUser];
  [self performSegueWithIdentifier:@"onBoarding" sender:self];
}


-(void)saveUserDetailsToDataManager:(id)userInfo
{
  [LCDataManager sharedDataManager].avatarUrl = userInfo[kFBAvatarImageUrlKey];
  [LCDataManager sharedDataManager].userID = userInfo[kUserIDKey];
  [LCDataManager sharedDataManager].userToken = userInfo[kAccessTokenKey];
}



@end
