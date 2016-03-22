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
+ (void)getInterestDetailsOfInterest:(NSString*)interestId WithSuccess:(void (^)(LCInterest* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCauseDetailsOfCause:(NSString*)causeId WithSuccess:(void (^)(LCCause* response))success andFailure:(void (^)(NSString *error))failure;

+ (void)followInterest:(LCInterest *)interest withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unfollowInterest:(LCInterest *)interest withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

+ (void)supportCause:(LCCause *)cause withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unsupportCause:(LCCause *)cause withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getInterestFollowersOfInterest:(NSString*)interestId lastUserId:(NSString*)lastId andPageNumber:(NSString*) page withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCauseFollowersOfCause:(NSString*)causeId pageNumber:(NSString*)page andLastID:(NSString*)lastID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;

+ (void)getCausesForSetOfInterests:(NSArray*)interests withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getThemesWithLastId:(NSString*)lastId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getInterestsForThemeId:(NSString*)themeId lastId:(NSString*)lastId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getPostsInInterest:(NSString *)interestID andLastPostID:(NSString*)lastID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getPostsInInterestByThankedOrder:(NSString *)interestID andLastPostID:(NSString*)lastID andPageNumber:(NSString*)pageNumber withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getPostsInCause:(NSString *)causeID andLastPostID:(NSString*)lastID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;

@end
