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


NSString * const kFBPublishActionsPermissionKey = @"publish_actions";
NSString * const kFBMessageKey = @"message";

@implementation LCSocialShareManager


#pragma mark- Twitter

+ (void)canShareToTwitter:(CanShareToTwitter)canShare
{
  ACAccountStore *account = [[ACAccountStore alloc] init];
  ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
   canShare(arrayOfAccounts.count > 0);
}

+ (void)shareToTwitterWithStatus:(NSString*)status andImage:(UIImage*)image
{
  
  ACAccountStore *account = [[ACAccountStore alloc] init];
  ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
    
    if (granted) {
      
      NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
      
      if ([arrayOfAccounts count] > 0) {
        
        ACAccount *twitterAccount = [arrayOfAccounts lastObject];
        NSDictionary *message = @{@"status": status};
        
        NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
        SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:requestURL
                                                       parameters:message];
        postRequest.account = twitterAccount;
        
        if (image) {
          
          NSData *myData = UIImagePNGRepresentation(image);
          [postRequest addMultipartData:myData withName:@"media" type:@"image/png" filename:@"TestImage"];
        }
        
        [postRequest performRequestWithHandler:^(NSData *responseData,NSHTTPURLResponse *urlResponse, NSError *error) {
          NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
          NSLog(@"Twitter HTTP response: %li \n %@", (long)[urlResponse statusCode], newStr);
          if (error) {
            [LCUtilityManager showAlertViewWithTitle:@"" andMessage:[error localizedDescription]];
          }
          else
          {
            if ([urlResponse statusCode] == 200) {
              NSLog(@"Posted to twitter successfully.");
            }
            else {
              NSLog(@"Posting to twitter failed.");
            }
          }
          
        }];
      }
      else
      {
        dispatch_async(dispatch_get_main_queue(), ^{
          [LCUtilityManager showAlertViewWithTitle:@"" andMessage:@"You must login to Twitter account"];
        });
      }
    }
    else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [LCUtilityManager showAlertViewWithTitle:@"" andMessage:@"You must grant access to use Twitter account for Legacy Connect. Please visit Settings > Twitter > and allow access to Legacy Connect "];
      });
      
      /*
       switch (error.code) {
       case ACErrorAccountNotFound: {
       dispatch_async(dispatch_get_main_queue(), ^{
       });
       break;
       }
       default: {
       break;
       }
       }
       */
    }
  }];
}


#pragma mark- Facebook

+ (void)canShareToFacebook:(void (^)(BOOL canPost))completionHandler
{
  FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
  if (accessToken && [accessToken hasGranted:kFBPublishActionsPermissionKey]) {
    
    NSLog(@"have the facces token...");
    completionHandler(YES);
    
  }
  else {
    
    [self loginToFacebookWithSuccess:^(id response) {
      
      NSLog(@"got access token");
      completionHandler(YES);
      
    } andFailure:^(NSString *error) {
      completionHandler(NO);
    }];
  }
  
}

+ (void)loginToFacebookWithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSLog(@"logging in to facebook");
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  LCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  [login logInWithPublishPermissions:@[kFBPublishActionsPermissionKey] fromViewController:appDelegate.window.rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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
      if ([result.grantedPermissions containsObject:kFBPublishActionsPermissionKey])
      {
        success(result);
      }
    }
  }];
}

- (void)shareToFacebookWithMessage:(NSString *)message andImage:(UIImage *)image
{
  
  //NSString *postMessage = @"good night friends";
  //UIImage *postImage = [UIImage imageNamed:@"profileFriend"];
  
  if (image) {
  
      FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
      photo.caption = message;
      photo.image = image;
      photo.userGenerated = YES;
      FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
      content.photos = @[photo];
    
      BOOL ok = [FBSDKShareAPI shareWithContent:content delegate:self];
      if (ok) {
        NSLog(@"Posted to facebook successfully.");
      }
      else {
        NSLog(@"Posting to facebook failed.");
      }
  }
  else {
    
    NSDictionary *params = @{kFBMessageKey : message};
      FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/feed"
                                                                     parameters:params
                                                                     HTTPMethod:@"POST"];
      [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
          NSLog(@"Posting to facebook failed.");
        }
        else{
          NSLog(@"Posted to facebook successfully.- %@",result);
        }
      }];
  }
}


#pragma mark- FBSDKSharingDelegate

- (void) sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
  
  NSLog(@"Facebook sharing completed: %@", results);
}

- (void) sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
  
  NSLog(@"Facebook sharing failed: %@", error);
}

- (void) sharerDidCancel:(id<FBSDKSharing>)sharer {
  
  NSLog(@"Facebook sharing cancelled.");
}



@end
