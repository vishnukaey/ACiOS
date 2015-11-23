//
//  LCRequest.m
//  LegacyConnect
//
//  Created by Kaey on 20/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCRequest.h"

@implementation LCRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"userID" : @"userId",
           @"requestID": @"id",
           @"addressCity" : @"addressCity",
           @"avatarURL" : @"avatarUrl",
           @"eventID" : @"eventId",
           @"eventName" : @"eventName",
           @"firstName": @"firstName",
           @"friendID" : @"friendId",
           @"lastName" : @"lastName",
           @"type" : @"type",
           @"eventImage" : @"eventImage"
           };
}

@end
