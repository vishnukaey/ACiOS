//
//  LCUserDetail.m
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUserDetail.h"

@implementation LCUserDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"userID": @"userId",
           @"email": @"email",
           @"firstName": @"firstName",
           @"lastName": @"lastName",
           @"dob": @"dob",
           @"avatarURL": @"avatarUrl",
           @"gender": @"gender",
           @"headerPhotoURL": @"headerPhotoUrl",
           @"location": @"addressCity",
           @"activationDate": @"memberSince",
           @"friendCount": @"friendCount",
           @"impactCount": @"impactCount",
           @"isFriend": @"isFriend",
           };
}

@end
