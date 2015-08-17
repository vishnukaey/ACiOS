//
//  LCInterest.m
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCInterest.h"
#import "LCCause.h"

@implementation LCInterest

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"interestID": @"id",
           @"name": @"name",
           @"descriptionText": @"description",
           @"logoURLLarge": @"interest_logo_large",
           @"logoURLSmall": @"interest_logo_small"
           };
}

//+ (NSValueTransformer *)causesJSONTransformer
//{
//  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCCause class]];
//}

@end
