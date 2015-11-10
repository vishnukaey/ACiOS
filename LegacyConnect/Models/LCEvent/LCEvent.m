//
//  LCEvent.m
//  LegacyConnect
//
//  Created by Vishnu on 8/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCEvent.h"

@implementation LCEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"name": @"name",
           @"eventID" : @"eventId",
           @"headerPhoto" : @"headerPhoto",
           @"followerCount" : @"followerCount",
           @"eventDescription": @"description",
           @"website": @"website",
           @"time": @"time",
           @"interestID": @"interestId",
           @"ownerFirstName": @"firstName",
           @"ownerLastName" : @"lastName",
           @"interestName" : @"interestName",
           @"userID" : @"userId",
           @"isOwner": @"isOwner",
           @"isFollowing": @"isFollowing",
           @"comments": @"comments"
           };
}

+ (NSValueTransformer *)commentsJSONTransformer
{
  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCComment class]];
}

@end
