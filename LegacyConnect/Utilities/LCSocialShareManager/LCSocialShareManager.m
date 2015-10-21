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

+ (BOOL)canShareToTwitter
{
  return NO;
}

+ (void)shareToFacebookWithData:(NSDictionary*)data
{
  ACAccountStore *accountStore = [[ACAccountStore alloc] init];
  
  ACAccountType *accountTypeFacebook = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
  
  NSDictionary *options = @{
                            ACFacebookAppIdKey: @"",
                            ACFacebookPermissionsKey: @[@"publish_stream",@"publish_actions"],
                            ACFacebookAudienceKey: ACFacebookAudienceFriends
                            };
  
  [accountStore requestAccessToAccountsWithType:accountTypeFacebook options:options completion:^(BOOL granted, NSError *error) {
    
    if(granted) {
      
      NSArray *accounts = [accountStore
                           accountsWithAccountType:accountTypeFacebook];
      ACAccount * _facebookAccount = [accounts lastObject];
      
      NSDictionary *parameters = @{@"access_token":_facebookAccount.credential.oauthToken,
                                   @"message": @"My first iOS Facebook posting"};
      
      NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
      
      SLRequest *feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                  requestMethod:SLRequestMethodPOST
                                                            URL:feedURL
                                                     parameters:parameters];
      
      //      [feedRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
      //
      //        NSLog(@"Request failed, %@", [urlResponse description]);
      //      }];
    } else {
      NSLog(@"[%@]",[error localizedDescription]);
      switch (error.code) {
        case ACErrorAccountNotFound: {
          dispatch_async(dispatch_get_main_queue(), ^{
//            SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//            [self presentViewController:composeViewController animated:NO completion:^{
//              //[composeViewController dismissViewControllerAnimated:NO completion:nil];
//            }];
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

+ (void)shareToTwitterWithData:(NSDictionary*)data
{
  ACAccountStore *account = [[ACAccountStore alloc] init];
  ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  [account requestAccessToAccountsWithType:accountType options:nil
                                completion:^(BOOL granted, NSError *error){
                                  if (granted == YES) {
                                    
                                    NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                                    
                                    if ([arrayOfAccounts count] > 0) {
                                      
                                      ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                                      
                                      NSDictionary *message = @{@"status": @"My First Twitter post from iOS"};
                                      
                                      NSURL *requestURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
                                      
                                      SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                                  requestMethod:SLRequestMethodPOST
                                                                                            URL:requestURL parameters:message];
                                      postRequest.account = twitterAccount;
                                      
                                      //                                      [postRequest performRequestWithHandler:^(NSData *responseData,NSHTTPURLResponse *urlResponse, NSError *error){
                                      //                                        NSLog(@"Twitter HTTP response: %li", (long)[urlResponse statusCode]);
                                      //                                      }];
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
