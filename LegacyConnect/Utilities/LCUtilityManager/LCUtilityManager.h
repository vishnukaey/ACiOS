//
//  LCUtilityManager.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCUserDetail.h"
#import <UIKit/UIKit.h>

@interface LCUtilityManager : NSObject

+ (BOOL)isNetworkAvailable;
+ (NSString *)performNullCheckAndSetValue:(NSString *)value;
+ (BOOL)validateEmail:(NSString*)emailString;
+ (BOOL)validatePassword:(NSString*)passwordString;
+ (NSString*) getStringValueOfBOOL:(BOOL)value;
+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (NSString *)getDateFromTimeStamp:(NSString *)timeStamp WithFormat:(NSString *)format;
+ (NSString *)getTimeStampStringFromDate:(NSDate *)date;
+ (NSString *)getAgeFromTimeStamp:(NSString *)timeStamp;
+ (NSString *)encodeToBase64String:(NSString *)string;
+ (void)saveUserDetailsToDataManagerFromResponse:(LCUserDetail *)user;
+ (NSString *)decodeFromBase64String:(NSString *)string;
+ (NSString *) generateUserTokenForUserID:(NSString*)userID andPassword:(NSString *)password;
+ (void)clearUserDefaultsForCurrentUser;
+ (void)saveUserDefaultsForNewUser;

+ (UITableViewCell*)getEmptyIndicationCellWithText:(NSString*)text;

//+(NSNumber*) getNSNumberFromString:(NSString*)string;


+ (NSArray *)getPhoneContacts;
+ (void)setGIAndMenuButtonVisibilityStatus:(BOOL)GIisHidden MenuVisibilityStatus:(BOOL)menuisHidden;

@end
