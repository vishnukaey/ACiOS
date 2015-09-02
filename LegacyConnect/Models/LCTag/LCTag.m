//
//  LCTag.m
//  LegacyConnect
//
//  Created by Vishnu on 8/13/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCTag.h"

@implementation LCTag


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"type": @"type",
           @"tagID": @"id",
           @"text": @"text"
           };
}

@end
