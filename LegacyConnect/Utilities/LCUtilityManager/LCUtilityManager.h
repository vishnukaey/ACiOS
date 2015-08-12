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
+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (NSString *)getDateFromTimeStamp:(NSString *)timeStamp WithFormat:(NSString *)format;
+ (NSString *)getTimeStampStringFromDate:(NSDate *)date;
+ (NSString *)encodeToBase64String:(NSString *)string;
+ (NSString *)decodeFromBase64String:(NSString *)string;
+ (NSString *) generateUserTokenForUserID:(NSString*)userID andPassword:(NSString *)password;
+ (void)clearUserDefaultsForCurrentUser;
+ (void)saveUserDefaultsForNewUser;


//+(NSNumber*) getNSNumberFromString:(NSString*)string;


+ (NSArray *)getPhoneContacts;

@end
