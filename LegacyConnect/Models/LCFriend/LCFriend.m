//
//  LCUser.m
//  LegacyConnect
//
//  Created by Vishnu on 7/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFriend.h"


@implementation LCFriend

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"userID": @"friendid",
           @"firstName": @"firstname",
           @"lastName": @"lastname",
           @"avatarURL": @"avatarurl",
           @"status": @"status"
           };
}

@end
