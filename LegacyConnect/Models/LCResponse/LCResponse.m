//
//  LCResponse.m
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCResponse.h"

@implementation LCResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @"status": @"status",
           @"message": @"message",
           @"data": @"data",
           };
}

@end
