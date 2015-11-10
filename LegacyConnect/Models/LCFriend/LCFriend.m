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
           @"createdAt": @"createdAt",
           @"userID": @"userId",
           @"friendId": @"friendId",
           @"firstName": @"firstName",
           @"lastName": @"lastName",
           @"avatarURL": @"avatarUrl",
           @"status" : @"status",
           @"isFriend": @"isFriend",
           @"location":@"location",
           @"isMember":@"isMember"
           };
}

@end
