//
//  LCAPIManager.h
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAPIManager : NSObject  


#pragma mark - Feeds

+ (void)getHomeFeedsWithLastFeedId:(NSString*)lastId success:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getUserDetailsOfUser:(NSString*)userID WithSuccess:(void (^)(LCUserDetail* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)searchForItem:(NSString*)searchItem withSuccess:(void (^)(LCSearchResult* searchResult))success andFailure:(void (^)(NSString *error))failure;
+ (void)updateProfile:(LCUserDetail*)user havingHeaderPhoto:(UIImage*)headerPhoto removedState:(BOOL) headerPhotoState andAvtarImage:(UIImage*)avtarImage removedState:(BOOL)avtarImageState withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getImpactsForUser:(NSString *)userID andLastImpactsID:(NSString*)lastID with:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)searchUserUsingsearchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure;
+ (void)getRequestNotificationsWithLastUserId:(NSString*)lastId withSuccess:(void (^)(NSArray* responses))success andfailure:(void (^)(NSString *error))failure;

#pragma mark - Post

+ (void)getPostDetailsOfPost:(NSString*)postID WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)createNewPost:(LCFeed*)post withImage:(UIImage*)image withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)updatePost:(LCFeed*)post withImage:(UIImage*)image withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)deletePost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)likePost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void) unlikePost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)commentPost:(LCFeed *)post comment:(NSString*)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)deleteCommentWithId:(NSString *)commentId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCommentsForPost:(NSString*)postId lastCommentId:(NSString*)lastId withSuccess:(void (^)(id response, BOOL isMore))success andfailure:(void (^)(NSString *error))failure;
+ (void)makePostAsMilestone:(NSString *)postId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)removeMilestoneFromPost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

#pragma mark - Interests and Causes

+ (void)getInterestsWithSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCausesForInterestID:(NSString*)InterestID andLastCauseID:(NSString*)lastCauseID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getUserInterestsAndCausesWithSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)saveCauses:(NSArray *)causes andInterests:(NSArray*)interests ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getMilestonesForUser:(NSString *)userID andLastMilestoneID:(NSString*)lastID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getInterestsForUser:(NSString*)userID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCausesForUser:(NSString*)userID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getInterestDetailsOfInterest:(NSString*)interestId WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCauseDetailsOfCause:(NSString*)causeId WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)followInterest:(NSString *)interestId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unfollowInterest:(NSString *)interestId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)supportCause:(NSString *)causeId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unsupportCause:(NSString *)causeId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getInterestFolowersOfInterest:(NSString*)interestId withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCauseFolowersOfCause:(NSString*)causeId withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;

#pragma mark- Friends and Requests

+ (void)getFriendsForUser:(NSString*)userId searchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure;
+ (void)sendFriendRequest:(NSString *)friendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)cancelFriendRequest:(NSString *)friendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)removeFriend:(NSString *)FriendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)acceptFriendRequest:(NSString *)friendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)rejectFriendRequest:(NSString *)friendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)sendFriendRequestFromContacts:(NSArray *)emailList withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)sendFriendRequestToFBFriends:(NSArray *)FBIDs withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

#pragma mark - Events

+ (void)getUserEventsForUserId:(NSString*)userId andLastEventId:(NSString*)lastEventId
                    withSuccess:(void(^)(NSArray *response))success andFailure:(void(^)(NSString* error))failure;
+ (void)createEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)updateEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto andImageStatus:(bool)status withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)addUsersWithUserIDs:(NSArray*)userIDs forEventWithEventID:(NSString*)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getEventDetailsForEventWithID:(NSString*)eventID withSuccess:(void (^)(LCEvent* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getListOfEventsForInterestID:(NSString*)InterestID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)followEvent:(LCEvent*)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unfollowEvent:(LCEvent*)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getMembersForEventID:(NSString*)eventID andLastEventID:(NSString*)lastEventID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCommentsForEvent:(NSString*)eventID lastCommentID:(NSString*)lastID withSuccess:(void (^)(id response, BOOL isMore))success andfailure:(void (^)(NSString *error))failure;
+ (void)postCommentToEvent:(LCEvent *)event comment:(NSString*)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)deleteEvent:(LCEvent *)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getMemberFriendsForEventID:(NSString*)eventID searchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure;
+ (void)rejectEventRequest:(NSString *)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

#pragma mark - Registration

+ (void)registerNewUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)performOnlineFBLoginRequest:(NSArray*)parameters withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)uploadImage:(UIImage *)image ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)performLoginForUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)forgotPasswordOfUserWithMailID:(NSString *)emailID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)resetPasswordWithPasswordResetCode:(NSString *)PasswordResetCode andNewPassword:(NSString*) password withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

#pragma maek - Notifications
+ (void)getNotificationCountWithStatus:(void (^)(BOOL status))status;
+ (void)getRecentNotificationsWithLastId:(NSString*)lastId withSuccess:(void(^)(id response))success andFailure:(void(^)(NSString*error))failure;
+ (void)markNotificationAsRead:(NSString*)notificationId andStatus:(void (^)(BOOL status))status;

#pragma mark - Settings
+ (void)signOutwithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)changePrivacy:(NSString *)newPrivacy withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)changeLegacyURL:(NSString *)newURL withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)changePassword:(NSString *)newPassword withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)changeEmail:(NSString *)newEmail withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getSettignsOfUserWithSuccess:(void (^)(LCSettings * responses))success andFailure:(void (^)(NSString *error))failure;

#pragma mark - version controll
+ (void)checkVersionWithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

@end
