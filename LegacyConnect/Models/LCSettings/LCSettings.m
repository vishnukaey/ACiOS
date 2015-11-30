//
//  LCSettings.m
//  LegacyConnect
//
//  Created by Jijo on 11/19/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSettings.h"

@implementation LCSettings

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"privacy" : @"privacy",
           @"legacyUrl": @"legacyUrl",
           @"email" : @"email",
           @"availablePrivacy" : @"availablePrivacy"
           };
}

@end
