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
+ (NSData*)performNormalisedImageCompression:(UIImage*) image;
+ (void)saveUserDetailsToDataManagerFromResponse:(LCUserDetail *)user;
+ (NSString *)decodeFromBase64String:(NSString *)string;
+ (NSString *) generateUserTokenForUserID:(NSString*)userID andPassword:(NSString *)password;
+ (void)clearUserDefaultsForCurrentUser;
+ (void)saveUserDefaultsForNewUser;

+ (UITableViewCell*)getEmptyIndicationCellWithText:(NSString*)text;
+ (void)setLCStatusBarStyle;

//+(NSNumber*) getNSNumberFromString:(NSString*)string;


+ (NSArray *)getPhoneContacts;
+ (void)setGIAndMenuButtonHiddenStatus:(BOOL)GIisHidden MenuHiddenStatus:(BOOL)menuisHidden;

+ (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString;

+ (UIView*)getNoResultViewWithText:(NSString*)text;
+ (UIView*)getSearchNoResultViewWithText:(NSString*)text;
+ (UITableViewCell*)getNextPageLoaderCell;
+ (BOOL)isaValidWebsiteLink :(NSString *)link;
+ (NSString *)getSpaceTrimmedStringFromString :(NSString *)string;
+ (BOOL)isEmptyString :(NSString *)string;

+ (void)showVersionOutdatedAlert;
+ (NSString *)getAppVersion;
+ (void)checkAppVersion;

+ (UIColor *)getThemeRedColor;
+ (float)getHeightOffsetForGIB;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(void)logoutUserClearingDefaults;

@end
