//
//  LCUtilityManager.m
//  LegacyConnect
//
//  Created by qbuser on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUtilityManager.h"

@implementation LCUtilityManager

+ (BOOL)isNetworkAvailable
{
  return [AFNetworkReachabilityManager sharedManager].reachable;
}


@end
