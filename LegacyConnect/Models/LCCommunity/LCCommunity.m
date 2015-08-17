//
//  LCCommunity.m
//  LegacyConnect
//
//  Created by qbuser on 8/17/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCommunity.h"

@implementation LCCommunity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"headerPhoto": @"headerPhoto",
           @"name": @"name",
           @"communityDescription": @"description",
           @"website": @"website",
           @"time": @"time",
           @"interestID": @"interestId",
           };
}

@end
