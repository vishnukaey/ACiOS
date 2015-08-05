//
//  LCUser.m
//  LegacyConnect
//
//  Created by Vishnu on 7/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUser.h"


@implementation LCUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"userID": @"id",
           @"email": @"email",
           @"firstName": @"firstName",
           @"lastName": @"lastName",
           @"dob": @"dob",
           @"avatarURL": @"avatarURL",
           };
}

@end
