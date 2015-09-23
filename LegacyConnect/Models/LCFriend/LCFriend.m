//
//  LCUser.m
//  LegacyConnect
//
//  Created by Vishnu on 7/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFriend.h"
static NSString *kAlreadyFriend = @"Already Friend";

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
           @"isFriend": @"isFriend"
           };
}

+ (BOOL)isAlreadyFriend:(LCFriend*)friendObj {
  if ([friendObj.isFriend isEqual:kAlreadyFriend]) {
    return YES;
  }
  return NO;
}

@end
