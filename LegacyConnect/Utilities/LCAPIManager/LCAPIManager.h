//
//  LCAPIManager.h
//  LegacyConnect
//
//  Created by qbuser on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAPIManager : NSObject

#pragma mark - GET API Requests

+ (void)getInterestsWithSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCausesForInterestID:(NSString*)InterestID andLastCauseID:(NSString*)lastCauseID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getUserDetailsOfUser:(NSString*)userID WithSuccess:(void (^)(LCUserDetail* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getHomeFeedsWithSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getFriendsWithSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getEventDetailsForEventWithID:(NSString*)eventID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;

#pragma mark - POST API Requests

+ (void) performLoginForUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)registerNewUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)UploadImage:(UIImage *)image ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)saveCauses:(NSArray *)causes ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void) sendFriendRequest:(LCFriend *)friend withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void) acceptFriendRequest:(LCFriend *)friend withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void) rejectFriendRequest:(LCFriend *)friend withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)createEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)addUsersWithUserIDs:(NSArray*)userIDs forEventWithEventID:(NSString*)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;


@end
