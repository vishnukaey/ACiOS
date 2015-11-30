//
//  LCRecentNotification.m
//  LegacyConnect
//
//  Created by qbuser on 19/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCRecentNotification.h"

@implementation LCRecentNotification

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"actionId": @"actionId",
           @"actionType": @"actionType",
           @"addressCity": @"addressCity",
           @"authorId": @"authorId",
           @"avatarUrl": @"avatarUrl",
           @"caption": @"caption",
           @"createdAt" : @"createdAt",
           @"entityId": @"entityId",
           @"entityType":@"entityType",
           @"firstName":@"firstName",
           @"lastName":@"lastName",
           @"notificationId":@"id",
           @"isRead":@"isRead",
           @"userId":@"userId",
           @"message" : @"message"
           };
}

@end
