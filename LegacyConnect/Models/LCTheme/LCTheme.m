//
//  LCTheme.m
//  LegacyConnect
//
//  Created by qbuser on 14/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCTheme.h"
#import "LCInterest.h"

@implementation LCTheme

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"uniqueID": @"uniqueId",
           @"image": @"image",
           @"name": @"name",
           @"themeID": @"themeId",
           @"interests": @"interests"
           };
}

+ (NSValueTransformer *)interestsJSONTransformer
{
  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCInterest class]];
}

@end
