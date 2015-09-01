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
           @"interestID":@"interestId",
           @"causeID": @"causeId",
           @"name": @"name",
           @"tagLine": @"tagline",
           @"logoURLLarge": @"causeLogoLarge",
           @"logoURLSmall": @"causeLogoSmall",
           @"isDeleted": @"isDeleted",
           @"isSupporting": @"isSupporting"
           };
}

@end
