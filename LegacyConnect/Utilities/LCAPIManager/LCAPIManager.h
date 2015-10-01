//
//  LCAPIManager.h
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAPIManager : NSObject  


#pragma mark - Feeds and Notifications

+ (void)getHomeFeedsWithSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getUserDetailsOfUser:(NSString*)userID WithSuccess:(void (^)(LCUserDetail* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)searchForItem:(NSString*)searchItem withSuccess:(void (^)(LCSearchResult* searchResult))success andFailure:(void (^)(NSString *error))failure;
+ (void)updateProfile:(LCUserDetail*)user havingHeaderPhoto:(UIImage*)headerPhoto removedState:(BOOL) headerPhotoState andAvtarImage:(UIImage*)avtarImage removedState:(BOOL)avtarImageState withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;


#pragma mark - Interests and Causes

+ (void)getInterestsWithSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCausesForInterestID:(NSString*)InterestID andLastCauseID:(NSString*)lastCauseID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)saveCauses:(NSArray *)causes andInterests:(NSArray*)interests ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getMilestonesForUser:(NSString *)userID andLastMilestoneID:(NSString*)lastID with:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;

#pragma mark- Friends and Requests

+ (void)getFriendsForUser:(NSString*)userId searchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure;
+ (void)sendFriendRequest:(LCFriend *)userFriend withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)cancelFriendRequest:(LCFriend *)userFriend withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)removeFriend:(LCFriend *)userFriend withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)acceptFriendRequest:(LCFriend *)userFriend withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)rejectFriendRequest:(LCFriend *)userFriend withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)sendFriendRequestFromContacts:(NSArray *)emailList withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)sendFriendRequestToFBFriends:(NSArray *)FBIDs withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

#pragma mark - Events

+ (void)createEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)updateEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)addUsersWithUserIDs:(NSArray*)userIDs forEventWithEventID:(NSString*)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getEventDetailsForEventWithID:(NSString*)eventID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getListOfEventsForInterestID:(NSString*)InterestID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)followEventWithEventID:(NSString*)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unfollowEventWithEventID:(NSString*)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

#pragma mark - Registration

+ (void)registerNewUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)performOnlineFBLoginRequest:(NSArray*)parameters withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)uploadImage:(UIImage *)image ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)performLoginForUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)forgotPasswordOfUserWithMailID:(NSString *)emailID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)resetPasswordWithPasswordResetCode:(NSString *)PasswordResetCode andNewPassword:(NSString*) password withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;


@end
