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
           @"interestID":@"interestid",
           @"causeID": @"causeid",
           @"name": @"name",
           @"tagLine": @"tagline",
           @"logoURLLarge": @"causelogolarge",
           @"logoURLSmall": @"causelogosmall",
           };
}

@end
