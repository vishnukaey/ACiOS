//
//  LCSearchResult.m
//  LegacyConnect
//
//  Created by Vishnu on 9/2/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSearchResult.h"

@implementation LCSearchResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"usersArray": @"users",
           @"interestsArray": @"interests",
           @"causesArray": @"causes"
           };
}

+ (NSValueTransformer *)usersArrayJSONTransformer
{
  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCUserDetail class]];
}

+ (NSValueTransformer *)interestsArrayJSONTransformer
{
  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCInterest class]];
}

+ (NSValueTransformer *)causesArrayJSONTransformer
{
  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCCause class]];
}

@end
