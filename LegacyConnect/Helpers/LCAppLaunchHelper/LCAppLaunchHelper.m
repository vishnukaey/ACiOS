//
//  LCAppLaunchHelper.m
//  LegacyConnect
//
//  Created by qbuser on 09/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCAppLaunchHelper.h"

static NSString *kQueryTokenKey = @"password_reset_token=";

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

@end
