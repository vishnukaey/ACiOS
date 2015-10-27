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

@interface LCSocialShareManager ()
@property (nonatomic, strong) STTwitterAPI *twitterAPI;
@property (nonatomic, strong) NSArray *twitterAccounts;
@property (nonatomic, strong) CanShareToTwitter canShareTwitterBlock;
@end

NSString * const kFBPublishActionsPermissionKey = @"publish_actions";
NSString * const kFBMessageKey = @"message";

@implementation LCSocialShareManager


#pragma mark- Twitter

- (void)canShareToTwitter:(void (^)(BOOL canShare))completionHandler
{
  //check if already granted permissions
  if ([[NSUserDefaults standardUserDefaults] valueForKey:kTWOauthTokenKey]) {
    self.twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:kTWConsumerKey consumerSecret:kTWConsumerSecretKey oauthToken:[[NSUserDefaults standardUserDefaults] valueForKey:kTWOauthTokenKey] oauthTokenSecret:[[NSUserDefaults standardUserDefaults] valueForKey:kTWOauthTokenSecretKey]];
//    [self.twitterAPI verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
      completionHandler(YES);
//    } errorBlock:^(NSError *error) {
//      [self getTwitterPermissions];
//    }];
    return;
  }
  [self getTwitterPermissions];
  self.canShareTwitterBlock = completionHandler;
}

- (void)getTwitterPermissions
{
  [self loginOnTheWeb];
}

- (void)loginWithiOSAccount:(ACAccount *)account withError:(NSString *)error
{
  self.twitterAPI = nil;
  self.twitterAPI = [STTwitterAPI twitterAPIOSWithAccount:account];
  
  [_twitterAPI verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
    
    self.canShareTwitterBlock(YES);
    
  } errorBlock:^(NSError *error) {
    self.canShareTwitterBlock(NO);
  }];
}

- (void)chooseAccount {
  ACAccountStore *accountStore = [[ACAccountStore alloc] init];
  ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      
      if(granted == NO) {
        [self loginWithiOSAccount:nil withError:@"Acccess not granted."];
        return;
      }
      self.twitterAccounts = [accountStore accountsWithAccountType:accountType];
      
      if([self.twitterAccounts count] >0) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select an account:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        actionSheet.view.tintColor = [UIColor blackColor];
        
        for(ACAccount *account in self.twitterAccounts) {
          UIAlertAction *addAction = [UIAlertAction actionWithTitle:account.username style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self loginWithiOSAccount:account withError:nil];
            
          }];
          [actionSheet addAction:addAction];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:cancelAction];
        UIViewController *rootController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootController presentViewController:actionSheet animated:YES completion:nil];
      }
      else
      {
        [self loginWithiOSAccount:nil withError:@"No twitter accounts"];
      }
    }];
  };
  
#if TARGET_OS_IPHONE &&  (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
  if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
    [accountStore requestAccessToAccountsWithType:accountType
                                 withCompletionHandler:accountStoreRequestCompletionHandler];
  } else {
    [accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:accountStoreRequestCompletionHandler];
  }
#else
  [accountStore requestAccessToAccountsWithType:accountType
                                             options:NULL
                                          completion:accountStoreRequestCompletionHandler];
#endif
  
}

- (IBAction)loginOnTheWeb {
  
  self.twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:kTWConsumerKey
                                               consumerSecret:kTWConsumerSecretKey];
  [_twitterAPI postTokenRequest:^(NSURL *url, NSString *oauthToken) {
    NSLog(@"-- url: %@", url);
    NSLog(@"-- oauthToken: %@", oauthToken);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OauthVerification:) name:kTwitterCallbackNotification object:nil];
    
//    NSArray *splitedUrl = [[url absoluteString] componentsSeparatedByString:@"https://api.twitter.com/oauth/"];
//    NSString *TWAppUrl;
//    if(splitedUrl.count>1)
//    {
//      TWAppUrl = [NSString stringWithFormat:@"%@",splitedUrl[1]];
//    }
//    NSURL *urlApp = [NSURL URLWithString: [NSString stringWithFormat:@"twitter://%@",TWAppUrl]];
//    if ([[UIApplication sharedApplication] canOpenURL:urlApp]){
//     [[UIApplication sharedApplication] openURL:urlApp];
//    }
//    else
//    {
        [[UIApplication sharedApplication] openURL:url];
//    }
  } authenticateInsteadOfAuthorize:NO
                  forceLogin:@(YES)
                  screenName:nil
               oauthCallback:[NSString stringWithFormat:@"%@://twitter_access_tokens/", kTwitterUrlScheme]
                  errorBlock:^(NSError *error) {
                    self.canShareTwitterBlock(NO);
                    NSLog(@"-- error: %@", error);
                  }];
}

- (void)OauthVerification :(NSNotification *)notification {
  NSDictionary *userInfo = notification.userInfo;
//  NSString *token = userInfo[@"oauth_token"];
  NSString *verifier = userInfo[@"oauth_verifier"];
  [_twitterAPI postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
    NSLog(@"-- screenName: %@", screenName);
    [[NSUserDefaults standardUserDefaults] setValue:_twitterAPI.oauthAccessToken forKey:kTWOauthTokenKey];
    [[NSUserDefaults standardUserDefaults] setValue:_twitterAPI.oauthAccessTokenSecret forKey:kTWOauthTokenSecretKey];
    self.canShareTwitterBlock(YES);
    /*
     At this point, the user can use the API and you can read his access tokens with:
     
     _twitter.oauthAccessToken;
     _twitter.oauthAccessTokenSecret;
     
     You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
     
     Next time, just instanciate STTwitter with the class method:
     
     +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
     
     Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
     */
    
  } errorBlock:^(NSError *error) {
    self.canShareTwitterBlock(NO);
    NSLog(@"-- %@", [error localizedDescription]);
  }];
}

- (void)shareToTwitterWithStatus:(NSString*)status andImage:(UIImage*)image
{
  if (image) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"postImage.png"];
    
    // Save image.
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    NSURL *url_ = [NSURL fileURLWithPath:filePath];
    [self.twitterAPI postStatusUpdate:status inReplyToStatusID:nil mediaURL:url_ placeID:nil latitude:nil longitude:nil uploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
    } successBlock:^(NSDictionary *status) {
      
    } errorBlock:^(NSError *error) {
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Twitter sharing failed."];
    }];
  }
  else
  {
    [self.twitterAPI postStatusUpdate:status inReplyToStatusID:nil latitude:nil longitude:nil placeID:nil displayCoordinates:nil trimUser:[NSNumber numberWithInteger:140] successBlock:^(NSDictionary *status) {
      
    } errorBlock:^(NSError *error) {
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Twitter sharing failed."];
    }];
  }
}

#pragma mark- Facebook

+ (void)canShareToFacebook:(void (^)(BOOL canShare))completionHandler
{
  FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
  if (accessToken && [accessToken hasGranted:kFBPublishActionsPermissionKey]) {
    
    NSLog(@"have facebook access token.");
    completionHandler(YES);
    
  }
  else {
    
    [self loginToFacebookWithSuccess:^(id response) {
      
      NSLog(@"got fb access token");
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
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:error.localizedDescription];
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
      else
      {
        failure(@"Permission Denied.");
      }
    }
  }];
}

- (void)shareToFacebookWithMessage:(NSString *)message andImage:(UIImage *)image
{
  if (image) {
    
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.caption = message;
    photo.image = image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    BOOL ok = [[FBSDKShareAPI shareWithContent:content delegate:self] share];
    if (ok) {
      NSLog(@"Posted to facebook successfully.");
    }
    else {
      NSLog(@"Posting to facebook failed.");
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Facebook sharing failed."];
    }
  }
  else {
    
    NSDictionary *params = @{kFBMessageKey : message};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/feed"
                                                                   parameters:params
                                                                   HTTPMethod:@"POST"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
      if (error) {
        NSLog(@"Posting to facebook failed. %@",error);
        [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Facebook sharing failed."];
      }
      else{
        NSLog(@"Posted to facebook successfully.- %@",result);
      }
    }];
  }
}


#pragma mark- FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
  
  NSLog(@"Facebook sharing completed: %@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
  
  NSLog(@"Facebook sharing failed: %@", error);
  [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Facebook sharing failed."];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
  
  NSLog(@"Facebook sharing cancelled.");
}
@end
