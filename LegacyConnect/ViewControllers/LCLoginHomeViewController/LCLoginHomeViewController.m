//
//  LCLoginHomeViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LCLoginHomeViewController.h"
#import "LCWebServiceManager.h"
#import "LCConstants.h"
#import "LCOnboardThemesVC.h"
#import "LCAcceptTermsViewController.h"
#import "LCConnectFriendsVC.h"

@interface LCLoginHomeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewYPosition;
@end

@implementation LCLoginHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (IS_IPHONE_4)
  {
    self.textViewYPosition.constant = -65.0f;
  } else if (IS_IPHONE_5)
  {
    self.textViewYPosition.constant = -45.0f;
  }
  // Cache data is removed completely during a new user sign-in.
  [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (IBAction)continueWithFBAction
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login logOut];
  [login logInWithReadPermissions:@[kEmailKey,@"public_profile",@"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    if (error)
    {
      LCDLog(@"error %@",error);
    }
    else if (result.isCancelled)
    {
      LCDLog(@"Cancelled");
    }
    else
    {
      if ([result.grantedPermissions containsObject:kEmailKey])
      {
        [self fetchUserDetailsFromFacebook];
      }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}


- (void) fetchUserDetailsFromFacebook
{
  if([FBSDKAccessToken currentAccessToken])
  {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id, email, name" forKey:kFieldsKey];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:kMeKey parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
      if (!error)
      {
        [self saveUserDetailsToDataManagerFromResponse:result];
        
        //save fb user id to NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *response = result;
        [defaults setValue:response[kIDKey] forKey:kFBUserIDKey];
        
        NSArray *userDetailsArray = [self getFBUserDetailsArray];
        
        [LCOnboardingAPIManager checkIfNewUser:[LCDataManager sharedDataManager].userEmail withSuccess:^(id response) {
          if([response[@"exists"] isEqualToString:@"0"])
          {
            UIStoryboard *signSB = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
            LCAcceptTermsViewController *termsVC = [signSB instantiateViewControllerWithIdentifier:@"LCAcceptTermsViewController"];
            [self.navigationController pushViewController:termsVC animated:YES];
          }
          else
          {
            [LCOnboardingAPIManager performOnlineFBLoginRequest:userDetailsArray withSuccess:^(id response) {
              [self loginUser:response[@"data"]];
              [MBProgressHUD hideHUDForView:self.view animated:YES];
            } andFailure:^(NSString *error) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
          }
        } andFailure:^(NSString *error){
          [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
      }
    }];
  }
}



- (void)saveUserDetailsToDataManagerFromResponse:(id)response
{
  NSDictionary *userInfo = response;
  [LCDataManager sharedDataManager].userEmail = [LCUtilityManager performNullCheckAndSetValue:userInfo[kEmailKey]];
  [LCDataManager sharedDataManager].userFBID = [LCUtilityManager performNullCheckAndSetValue:userInfo[kIDKey]];
  [LCDataManager sharedDataManager].firstName = [LCUtilityManager performNullCheckAndSetValue:[FBSDKProfile currentProfile].firstName];
  [LCDataManager sharedDataManager].lastName = [LCUtilityManager performNullCheckAndSetValue:[FBSDKProfile currentProfile].lastName];
  [LCDataManager sharedDataManager].avatarUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[LCDataManager sharedDataManager].userFBID];
  [LCDataManager sharedDataManager].dob = [LCUtilityManager performNullCheckAndSetValue:userInfo[kDobKey]];
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
  [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)saveUserDetailsToDataManager:(id)userInfo
{
  [LCDataManager sharedDataManager].avatarUrl = userInfo[kFBAvatarImageUrlKey];
  [LCDataManager sharedDataManager].userID = userInfo[kUserIDKey];
  [LCDataManager sharedDataManager].userToken = userInfo[kAccessTokenKey];
}

- (void)goToUpdatePassword:(NSNotification*)notification {
  
  NSDictionary *userInfo = notification.userInfo;
  
  NSMutableArray * viewArray = [[NSMutableArray alloc] initWithArray:[self.navigationController viewControllers]];
  LCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:kLoginStoryBoardID];
  [viewArray addObject:loginVC];
  LCUpdatePasswordViewController *updatePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:kUpdatePasswordStoryBoardID];
  updatePasswordVC.delegate = loginVC;
  updatePasswordVC.token = userInfo[kResetPasswordTokenKey];
  [viewArray addObject:updatePasswordVC];
  self.navigationController.viewControllers = viewArray;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


- (void)viewDidDisappear: (BOOL)animated
{
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)signInButtonClicked:(id)sender
{
  LCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCLoginViewController"];
  [self.navigationController pushViewController:loginVC animated:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"onBoarding"]) {
    
    LCOnboardThemesVC *recentView = segue.destinationViewController;
    recentView.fromFacebook = YES;
  }
}
@end
