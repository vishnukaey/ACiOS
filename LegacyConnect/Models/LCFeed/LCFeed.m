//
//  LCFeed.m
//  LegacyConnect
//
//  Created by Vishnu on 8/13/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeed.h"

@implementation LCFeed

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"feedId" : @"id",
           @"userID": @"userId",
           @"firstName": @"firstName",
           @"lastName": @"lastName",
           @"message": @"message",
           @"avatarURL": @"avatarUrl",
           @"commentCount": @"commentCount",
           @"comments": @"comments",
           @"likeCount": @"likeCount",
           @"createdAt": @"createdAt",
           @"isMilestone": @"isMilestone",
           @"image": @"image",
           @"entityType": @"entityType",
           @"entityID": @"entityId",
           @"interestID": @"interestId",
           @"interestName": @"interestName",
           @"caption": @"caption",
           @"location": @"location",
           @"didLike": @"didLike",
           @"postType": @"postType",
           @"postTags": @"postTags",
           @"id": @"id",
           };
}

+ (NSValueTransformer *)posttagsJSONTransformer
{
  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCTag class]];
}

@end
