//
//  LCNewPost.m
//  LegacyConnect
//
//  Created by Akhil K C on 10/13/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCNewPost.h"

@implementation LCNewPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"message": @"message",
           @"isMilestone": @"isMilestone",
           @"entityType": @"entityType",
           @"entityID": @"entityId",
           @"location": @"location",
           @"postTags": @"postTags",
           };
}

+ (NSValueTransformer *)postTagsJSONTransformer
{
  return [MTLJSONAdapter arrayTransformerWithModelClass:[LCTag class]];
}

@end
