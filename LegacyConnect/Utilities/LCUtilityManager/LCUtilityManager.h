//
//  LCUtilityManager.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUtilityManager : NSObject

+ (BOOL)isNetworkAvailable;
+ (NSString *)performNullCheckAndSetValue:(NSString *)value;
+ (NSArray *)getPhoneContacts;
+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (NSString *)getDateFromTimeStamp:(NSString *)timeStamp WithFormat:(NSString *)format;
+ (NSString *)getTimeStampStringFromDate:(NSDate *)date;
@end
