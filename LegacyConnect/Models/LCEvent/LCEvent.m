//
//  LCEvent.m
//  LegacyConnect
//
//  Created by qbuser on 8/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCEvent.h"

@implementation LCEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"name": @"name",
           @"eventDescription": @"description",
           @"website": @"website",
           @"time": @"time",
           @"interestID": @"interestId",
           };
}

@end
