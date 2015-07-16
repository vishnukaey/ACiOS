//
//  LCUtilityManager.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUtilityManager.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>


@implementation LCUtilityManager

+ (BOOL)isNetworkAvailable
{
  return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (NSString *)performNullCheckAndSetValue:(NSString *)value
{
  if (value && ![value isKindOfClass:[NSNull class]])
  {
    return value;
  }
  return kEmptyStringValue;
}

@end
