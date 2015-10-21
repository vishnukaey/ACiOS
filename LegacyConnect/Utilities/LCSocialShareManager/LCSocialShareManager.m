//
//  LCSocialShareManager.m
//  LegacyConnect
//
//  Created by qbuser on 20/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSocialShareManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation LCSocialShareManager

+ (BOOL)canShareToFacebook
{
  return NO;
}

+ (BOOL)canShareToTwitter
{
  return NO;
}


+ (void)checkFacebookAvailabilityWithSuccess:(void (^)(BOOL canPost))completionHandler
{
  if ([FBSDKAccessToken currentAccessToken]) {
    completionHandler(YES);
  }
  
  ACAccountStore *accountStore = [[ACAccountStore alloc] init];
  
  
  ACAccountType *accountTypeFacebook = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
  
  NSDictionary *options = @{
                            ACFacebookAppIdKey: @"535164313296078",
                            ACFacebookPermissionsKey: @[@"publish_actions"],
                            ACFacebookAudienceKey: ACFacebookAudienceOnlyMe //change to everyone
                            };
  [accountStore requestAccessToAccountsWithType:accountTypeFacebook options:options completion:^(BOOL granted, NSError *error) {
    if (granted) {
      completionHandler(YES);
    }
    else {
      NSLog(@"[%@]",[error localizedDescription]);
      if (error.code == ACErrorAccountNotFound) {
        [self loginToFacebookWithSuccess:^(id response) {
          
          
        } andFailure:^(NSString *error) {
          
        }];
      }
    }
  }];
  
}

+ (void)loginToFacebookWithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login logOut];
  LCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  [login logInWithReadPermissions:@[kEmailKey,@"public_profile",@"user_friends"] fromViewController:appDelegate.window.rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    if (error)
    {
      NSLog(@"error %@",error);
      failure(error.localizedDescription);
    }
    else if (result.isCancelled)
    {
      NSLog(@"Cancelled");
      failure(@"Cancelled");
    }
    else
    {
      if ([result.grantedPermissions containsObject:kEmailKey])
      {
        success(result);
        //[LCDataManager sharedDataManager].userFBID = result.token.tokenString;
        //NSLog(@"token 2--%@",[FBSDKAccessToken currentAccessToken].tokenString);
      }
    }
  }];
}

+ (void)shareToFacebookWithData:(NSDictionary*)data
{
  
  NSLog(@"token 1--%@",[FBSDKAccessToken currentAccessToken].tokenString);
  NSString *postMessage = @"test post";
  UIImage *postImage = nil;//[UIImage imageNamed:@"userProfilePic"];
  
  ACAccountStore *accountStore = [[ACAccountStore alloc] init];
  
  ACAccountType *accountTypeFacebook = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
  
  NSDictionary *options = @{
                            ACFacebookAppIdKey: @"535164313296078",
                            ACFacebookPermissionsKey: @[@"publish_actions"],
                            ACFacebookAudienceKey: ACFacebookAudienceOnlyMe
                            };
  
  [accountStore requestAccessToAccountsWithType:accountTypeFacebook options:options completion:^(BOOL granted, NSError *error) {
    
    if(granted) {
      NSArray *accounts = [accountStore
                           accountsWithAccountType:accountTypeFacebook];
      ACAccount * facebookAccount = [accounts lastObject];
      
      NSDictionary *parameters = @{@"access_token" : facebookAccount.credential.oauthToken,
                                   @"message": postMessage};
      
      SLRequest *feedRequest;
      if (postImage) {
        
        NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
        feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                         requestMethod:SLRequestMethodPOST
                                                   URL:feedURL
                                            parameters:parameters];
        NSData *imageData = UIImagePNGRepresentation(postImage);
        [feedRequest addMultipartData:imageData
                             withName:@"source"
                                 type:@"multipart/form-data"
                             filename:@"image.png"];
        
      }
      else {
        NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
        feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                         requestMethod:SLRequestMethodPOST
                                                   URL:feedURL
                                            parameters:parameters];
      }
      
      [feedRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        
        NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"FB Request completed, %@ \n\n %@", [urlResponse description],newStr);
        
      }];
      
    } else {
      NSLog(@"[%@]",[error localizedDescription]);
      if (error.code == ACErrorAccountNotFound) {
        [self loginToFacebookWithSuccess:^(id response) {
          
        } andFailure:^(NSString *error) {
          
        }];
      }
      else {
        [LCUtilityManager showAlertViewWithTitle:@"Can't Post To Facebook" andMessage:[error localizedDescription]];
      }
      
      //      switch (error.code) {
      //        case ACErrorAccountNotFound: {
      //          dispatch_async(dispatch_get_main_queue(), ^{
      ////            SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
      ////            [self presentViewController:composeViewController animated:NO completion:^{
      ////              //[composeViewController dismissViewControllerAnimated:NO completion:nil];
      ////            }];
      //          });
      //          break;
      //        }
      //        default: {
      //          NSLog(@"%s %x %@", __PRETTY_FUNCTION__, granted, error);
      //          //[[[UIAlertView alloc] initWithTitle:@"D:" message:error.localizedFailureReason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
      //          break;
      //        }
      //      }
    }
  }];
}



+ (void)shareToTwitterWithData:(NSDictionary*)data
{
  UIImage *postImage = [UIImage imageNamed:@"userProfilePic"];
  
  
  ACAccountStore *account = [[ACAccountStore alloc] init];
  ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
    
    if (granted == YES) {
      
      NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
      
      if ([arrayOfAccounts count] > 0) {
        
        ACAccount *twitterAccount = [arrayOfAccounts lastObject];
        
        NSDictionary *message = @{@"status": @"Twitter post from iOS without image"};
        
        SLRequest *postRequest;
        if (postImage) {
          
          NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
          SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                      requestMethod:SLRequestMethodPOST
                                                                URL:requestURL
                                                         parameters:nil];
          
          NSData *imageData = UIImagePNGRepresentation(postImage);
          
          [postRequest addMultipartData:imageData
                               withName:@"media"
                                   type:@"image/png"
                               filename:@"image.png"];
          [postRequest addMultipartData:imageData
                               withName:@"media[]"
                                   type:@"multipart/form-data"
                               filename:@"image.png"];
          
          [postRequest addMultipartData:[@"my post" dataUsingEncoding:NSUTF8StringEncoding]
                               withName:@"status"
                                   type:@"multipart/form-data"
                               filename:nil];

        }
        else {
          
          NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
          postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                      requestMethod:SLRequestMethodPOST
                                                                URL:requestURL
                                                         parameters:message];
        }
        
        
        
        postRequest.account = twitterAccount;
        
        [postRequest performRequestWithHandler:^(NSData *responseData,NSHTTPURLResponse *urlResponse, NSError *error){
          NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
          NSLog(@"Twitter HTTP response: %li \n %@", (long)[urlResponse statusCode], newStr);
          if (error) {
            [LCUtilityManager showAlertViewWithTitle:@"" andMessage:[error localizedDescription]];
          }
          else {
            if ([urlResponse statusCode] == 200) {
              NSLog(@"Posted to twitter successfully.");
            }
            else {
              NSLog(@"Posting to twitter failed.");
            }
          }
          
        }];
      }
    }
    else {
      NSLog(@"[%@]",[error localizedDescription]);
      switch (error.code) {
        case ACErrorAccountNotFound: {
          dispatch_async(dispatch_get_main_queue(), ^{
            //                                          SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            //                                          [self presentViewController:composeViewController animated:NO completion:^{
            //                                            [composeViewController dismissViewControllerAnimated:NO completion:nil];
            //                                          }];
          });
          break;
        }
        default: {
          NSLog(@"%s %x %@", __PRETTY_FUNCTION__, granted, error);
          //[[[UIAlertView alloc] initWithTitle:@"D:" message:error.localizedFailureReason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
          break;
        }
      }
      
    }
  }];
}

@end
