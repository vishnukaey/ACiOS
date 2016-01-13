//
//  LCThemeAPIManager.h
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCThemeAPIManager : NSObject

+ (void)getAllInterestsWithLastId:(NSString*)lastId success:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCausesForInterestID:(NSString*)InterestID andLastCauseID:(NSString*)lastCauseID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)saveCauses:(NSArray *)causes andInterests:(NSArray*)interests ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getInterestDetailsOfInterest:(NSString*)interestId WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCauseDetailsOfCause:(NSString*)causeId WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure;

+ (void)followInterest:(LCInterest *)interest withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unfollowInterest:(LCInterest *)interest withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

+ (void)supportCause:(NSString *)causeId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unsupportCause:(NSString *)causeId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getInterestFolowersOfInterest:(NSString*)interestId withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCauseFolowersOfCause:(NSString*)causeId withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;


+ (void)getCausesForSetOfInterests:(NSArray*)interests withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getThemesWithLastId:(NSString*)lastId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getInterestsForThemeId:(NSString*)themeId lastId:(NSString*)lastId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

@end
