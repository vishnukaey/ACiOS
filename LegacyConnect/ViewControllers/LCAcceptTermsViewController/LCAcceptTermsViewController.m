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

@implementation LCAcceptTermsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  _acceptTermsButton.layer.cornerRadius = 5.0;
  _readTermsButton.layer.cornerRadius = 5.0;


//  _acceptTermsButton.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
//  _acceptTermsButton.layer.borderWidth = 1.0;

  
  // Do any additional setup after loading the view.
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
  UIStoryboard *signSB = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  LCTermsOfServiceViewController *termsVC = [signSB instantiateViewControllerWithIdentifier:@"LCTermsOfServiceViewController"];
  [self.navigationController pushViewController:termsVC animated:YES];
}


-(IBAction)acceptTermsofService:(id)sender
{
  NSArray *userDetailsArray = [self getFBUserDetailsArray];
  [LCOnboardingAPIManager performOnlineFBLoginRequest:userDetailsArray withSuccess:^(id response) {
    [self loginUser:response[@"data"]];
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
