//
//  LCSettingsAPIManager.h
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSettingsAPIManager : NSObject

+ (void)signOutwithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)changePrivacy:(NSString *)newPrivacy withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)changeLegacyURL:(NSString *)newURL withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)changePassword:(NSString *)newPassword withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)changeEmail:(NSString *)newEmail withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getSettignsOfUserWithSuccess:(void (^)(LCSettings * responses))success andFailure:(void (^)(NSString *error))failure;

+ (void)checkVersionWithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getBlockedUsersWithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

@end
