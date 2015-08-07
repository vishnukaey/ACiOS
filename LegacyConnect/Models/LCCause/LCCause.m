//
//  LCCause.m
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCause.h"

@implementation LCCause

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"causeID": @"id",
           @"name": @"name",
           @"tagLine": @"tagLine",
           @"interestID": @"interestId",
           @"logoURLLarge": @"causeLogoLarge",
           @"logoURLSmall": @"causeLogoSmall",
           };
}

@end
