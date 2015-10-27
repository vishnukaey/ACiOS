//
//  LCComment.m
//  LegacyConnect
//
//  Created by qbuser on 15/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCComment.h"

@implementation LCComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"commentId" : @"id",
           @"avatarUrl": @"avatarUrl",
           @"commentText" : @"comment",
           @"createdAt" : @"createdAt",
           @"firstName" : @"firstName",
           @"lastName": @"lastName",
           @"userId" : @"userId"
           };
}

@end
