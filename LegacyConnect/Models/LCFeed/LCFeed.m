//
//  LCFeed.m
//  LegacyConnect
//
//  Created by qbuser on 8/13/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeed.h"

@implementation LCFeed

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"userID": @"userId",
           @"postID": @"postId",
           @"firstName": @"firstName",
           @"lastName": @"lastName",
           @"message": @"message",
           @"avatarURL": @"avatarUrl",
           @"commentCount": @"commentCount",
           @"likeCount": @"likeCount",
           @"createdAt": @"createdAt",
           @"isMilestone": @"isMilestone",
           @"image": @"image",
           @"entityType": @"entityType",
           @"entityID": @"entityId",
           @"entityName": @"entityName",
           @"caption": @"caption",
           @"location": @"location",
           @"didLike": @"didLike",
           @"postType": @"postType",
           @"postTags": @"posttags",
           };
}

+ (NSValueTransformer *)posttagsJSONTransformer
{
  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCTag class]];
}

@end
