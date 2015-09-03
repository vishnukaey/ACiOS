//
//  LCUserDetail.m
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUserDetail.h"
#import <objc/runtime.h>

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
           @"accessToken": @"accessToken"
           };
}

- (void)performNullCheck
{
  unsigned int outCount, i;
  objc_property_t *properties = class_copyPropertyList([self class], &outCount);
  for (i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    NSString *propertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
    const char * type = property_getAttributes(property);
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1)
    {
      NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
      if ([typeClassName isEqualToString:@"NSString"])
      {
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue == (id)[NSNull null] || propertyValue == nil) {
          [self setValue:@"" forKey:propertyName];
        }
      }
    }
  }
  free(properties);
}

@end
