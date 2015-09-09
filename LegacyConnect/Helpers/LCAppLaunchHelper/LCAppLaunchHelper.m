//
//  LCAppLaunchHelper.m
//  LegacyConnect
//
//  Created by qbuser on 09/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCAppLaunchHelper.h"

static NSString *kQueryTokenKey = @"password_reset_token=";
static NSString *kNeedResetPassword = @"needt_to_show_password_Reset";
static NSString *kPasswordResetToken = @"reset_password_token";

@implementation LCAppLaunchHelper

/**
 * Method for extracting password reset token from url query.
 */
+ (NSString*)getPasswordResetTokenFromURLQuery:(NSString*)queryString
{
  NSString * queryTokenKey = kQueryTokenKey;
  NSString * token = nil;
  if ([queryString containsString:queryTokenKey])
  {
    NSRange tokenKeyRange = [queryString rangeOfString:queryTokenKey];
    token = [queryString substringFromIndex:tokenKeyRange.location + tokenKeyRange.length];
  }
  return token;
}

+ (void)setNeedsToShowPasswordResetScreenWithToken:(NSString*)token
{
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:true forKey:kNeedResetPassword];
  [defaults setObject:token forKey:kPasswordResetToken];
  [defaults synchronize];
}

+ (void)clearPasswordResetToken {
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:false forKey:kNeedResetPassword];
  [defaults removeObjectForKey:kPasswordResetToken];
  [defaults synchronize];
}

+ (BOOL)needsToShowPasswordResetScreen
{
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  return [defaults boolForKey:kNeedResetPassword];
}

+ (NSString*)getPasswordResetToken
{
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  return [defaults objectForKey:kPasswordResetToken];
}

@end
