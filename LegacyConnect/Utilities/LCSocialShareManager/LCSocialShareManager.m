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


@implementation LCSocialShareManager

+ (BOOL)canShareToFacebook
{
  return NO;
}

+ (void)canShareToTwitter:(CanShareToTwitter)canShare
{
  ACAccountStore *account = [[ACAccountStore alloc] init];
  ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
   canShare(arrayOfAccounts.count > 0);
}

+ (void)shareToFacebookWithData:(NSDictionary*)data
{
  UIImage *postImage = [UIImage imageNamed:@"userProfilePic"];
  
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
      
      NSDictionary *parameters = @{@"message": @"new post from app with image"};
      
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
      feedRequest.account = facebookAccount;
      
      [feedRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        
        NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"FB Request completed, %@ \n\n %@", [urlResponse description],newStr);
        
      }];
    } else {
      NSLog(@"[%@]",[error localizedDescription]);
      [LCUtilityManager showAlertViewWithTitle:@"Can't Post To Facebook" andMessage:[error localizedDescription]];
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

@end
