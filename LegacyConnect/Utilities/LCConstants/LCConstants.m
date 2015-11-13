//
//  LCConstants.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCConstants.h"

@implementation LCConstants

#define QA_SERVER 0
#define DEV_SERVER 1
#define STAGING_SERVER 2

/* Set server to be used */
#define CURRENT_SERVER DEV_SERVER

#if CURRENT_SERVER == QA_SERVER
/* QA url */
NSString *const kBaseURL = @"http://10.3.0.55:8000/";
NSString *const kFBAppID = @"785925134858928";
NSString *const kFBAppDisplayName = @"LegacyConnectGreeshmaLocal";
NSString *const kFBURLScheme = @"fb785925134858928";

#elif CURRENT_SERVER == DEV_SERVER
///* Development url */
NSString *const kBaseURL = @"http://dev.legacyconnect.com/";
NSString *const kFBAppID = @"781451981972910";
NSString *const kFBAppDisplayName = @"LegacyConnectDev";
NSString *const kFBURLScheme = @"fb781451981972910";

#elif CURRENT_SERVER == STAGING_SERVER
///* Staging url */
NSString *const kBaseURL = @"https://staging.legacyconnect.com/";
NSString *const kFBAppID = @"535164313296078";
NSString *const kFBAppDisplayName = @"LegacyConnect";
NSString *const kFBURLScheme = @"fb535164313296078";

#endif
NSString *const kTWConsumerKey = @"IiYfEw17iKn2jTcWjp4H2QfYo";
NSString *const kTWConsumerSecretKey = @"pBPJNqVUXdfkeulFZuXf4Epd0SSXsLwOXYqgeNkCWC4QlUJmiv";

NSString *const kLoginURL = @"api/login";
NSString *const kRegisterURL = @"api/user";
NSString *const kEditProfileURL = @"api/user/edit";
NSString *const kFBLoginURL = @"api/user/fbLogin";
NSString *const kUploadUserImageURL = @"api/user/profileImage";

NSString *const kGetInterestURL = @"api/interest";
NSString *const kGetInterestsURL = @"api/interests";
NSString *const kGetUserInterestsURL = @"api/user/interests";
NSString *const kGetInterestFollowersURL = @"api/interest/users";
NSString *const kIneterestsFollowURL = @"api/interest/follow";
NSString *const kIneterestsUnfollowURL = @"api/interest/unfollow";
NSString *const kGetInterestsAndCausesURL = @"api/user/getUserInterestsWithCauses";

NSString *const kGetCauseURL = @"api/cause";
NSString *const kGetCausesURL = @"api/causes";
NSString *const kGetUserCausesURL = @"api/user/causes";
NSString *const kGetCauseFollowersURL = @"api/cause/users";
NSString *const kCauseSuppotURL = @"api/cause/support";
NSString *const kCauseUnsuppotURL = @"api/cause/unsupport";

NSString *const kGetFeedsURL = @"api/feed";
NSString *const kGetMilestonesURL = @"api/user/milestone";
NSString *const kGetImpactsURL = @"api/user/impact";
NSString *const kGetUserEventsURL = @"api/user/events";
NSString *const kFriendsURL = @"api/user/friend";
NSString *const kEventsURL = @"api/event";
NSString *const kRejectFriendURL = @"api/user/friend/decline";
NSString *const kAcceptFriendURL = @"api/user/friend/accept";
NSString *const kCancelFriendURL = @"api/user/friend/cancel";
NSString *const kUnfollowEventURL = @"api/event/unfollow";
NSString *const kFollowEventURL = @"api/event/follow";
NSString *const kAddUsersToEventURL = @"api/event/users";
NSString *const kForgotPasswordURL = @"api/user/forgotPassword";
NSString *const kUpdatePasswordURL = @"api/user/resetPassword";
NSString *const kLogOutURL = @"";
NSString *const kContactFriendsURL = @"api/user/friends";
NSString *const kFBContactFriendsURL = @"api/user/fbFriends";
NSString *const kprofileEditURL = @"api/user/edit";
NSString *const kPostURL = @"api/post";
NSString *const kPostEditURL = @"api/post/edit";
NSString *const kPostLikeURL = @"api/post/like";
NSString *const kPostUnlikeURL = @"api/post/unlike";
NSString *const kPostCommentURL = @"api/post/comment";
NSString *const kPostCommentsURL = @"api/post/comments";
NSString *const kPostMilestoneURL = @"api/post/milestone";



NSString *const kMainStoryBoardIdentifier = @"Main";
NSString *const kSignupStoryBoardIdentifier = @"SignUp";
NSString *const kProfileStoryBoardIdentifier = @"Profile";
NSString *const kInterestsStoryBoardIdentifier = @"Interests";
NSString *const kCommunityStoryBoardIdentifier = @"Actions";
NSString *const kNotificationStoryBoardIdentifier = @"Notification";
NSString *const kCreatePostStoryBoardIdentifier = @"CreatePost";



NSString *const kHomeFeedsStoryBoardID = @"LCFeedsHomeViewController";
NSString *const kChooseCommunityStoryBoardID = @"LCChooseActionsInterest";
NSString *const kUpdatePasswordStoryBoardID = @"LCUpdatePasswordViewController";
NSString *const kLoginStoryBoardID = @"LCLoginViewController";
NSString *const kForgotPasswordStoryBoardID = @"LCForgotPasswordViewController";



NSString *const kAuthorizationKey = @"Authorization";
NSString *const kResponseCode = @"status";
NSString *const kResponseMessage = @"message";
NSString *const kResponseData = @"data";
NSString *const kUsersKey = @"users";
NSString *const kInterestsKey = @"interests";
NSString *const kCausesKey = @"causes";
NSString *const kInterestIDKey = @"interestId";
NSString *const kCauseIDKey = @"causeId";
NSString *const kEventIDKey = @"eventId";
NSString *const kLastCauseIDKey = @"lastCauseId";
NSString *const kFriendsKey = @"friends";
NSString *const kFriendIDKey = @"friendId";
NSString *const kPostIDKey = @"postId";
NSString *const kFeedsKey = @"feeds";
NSString *const kMileStonesKey = @"milestones";
NSString *const kImpactsKey = @"impacts";
NSString *const kPostCommentKey = @"comment";
NSString *const kPostCommentsKey = @"comments";
NSString *const kPostCommentIdKey = @"commentId";
NSString *const kLastIdKey = @"lastId";

NSString *const kLoginStatusKey = @"logged_in";
NSString *const kUserTokenKey = @"user_token";


NSString *const kStatusCodeSuccess = @"success";
NSString *const kStatusCodeFailure = @"failure";

NSString *const kIDKey = @"id";
NSString *const kRange = @"range";
NSString *const kMeKey = @"me";
NSString *const kUserIDKey = @"userId";
NSString *const kFirstNameKey = @"firstName";
NSString *const kLastNameKey = @"lastName";
NSString *const kEmailKey = @"email";
NSString *const kFieldsKey = @"fields";
NSString *const kEventsKey = @"events";
NSString *const kAccessTokenKey = @"accessToken";
NSString *const kPasswordKey = @"password";
NSString *const kDobKey = @"dob";
NSString *const kFBUserIDKey = @"fbUid";
NSString *const kFBIDsKey = @"fbIds";
NSString *const kFBAvatarImageUrlKey = @"avatarUrl";
NSString *const kFBAccessTokenKey = @"fbAccessToken";
NSString *const kUserImageData = @"image";
NSString *const kUserimageExtension = @"imageExtension";
NSString *const kPasswordResetCodeKey = @"passwordResetCode";
NSString *const kContactEmailsKey = @"emails";

NSString *const kEmptyStringValue = @"";
NSString *const kDefaultDateFormat = @"yyyy-mm-dd";

NSString *const kHomefeedCellID = @"homefeedCell";
NSString *const kCommentsfeedCellID = @"commentfeedCell";

NSString *const kWordType = @"type";
NSString *const kFeedTagTypeCause = @"cause";
NSString *const kFeedTagTypeInterest = @"interest";
NSString *const kFeedTagTypeUser = @"user";

NSString *const kTwitterUrlScheme = @"twitterUrlScheme";
NSString *const kLCUrlScheme = @"legacyconnect";
NSString *const kResetPasswordTokenKey = @"password_reset_token";
NSString *const kResetPasswordNotificationName = @"password_reset_notification";
NSString *const kTwitterCallbackNotification = @"twitter_callback_notification";

NSString *const kUserDataUpdatedNotification = @"user_data_updated_notification";

NSString *const kUserProfileUpdateNotification = @"userProfileUpdated";
NSString *const kUserProfileFrinendsUpdateNotification = @"userProfileFriendsUpdated";
NSString *const kUserProfileImpactsUpdateNotification = @"userProfileImpactsUpdated";
NSString *const kfeedUpdatedotification = @"feedUpdated";

NSString *const kfeedUpdateEventKey = @"updated_feed";
NSString *const kfeedDeletedEventKey = @"deleted_feed";

NSString *const keventUpdateEventKey = @"updated_event";
NSString *const keventDeletedEventKey = @"deleted_event";


NSString *const kEventMemberCountUpdatedNotification = @"EventMemberCountUpdated";
NSString *const kEventDetailsUpdatedNotification = @"EventDetailsUpdated";
NSString *const kEventDeletedNotification = @"EventDeleted";
NSString *const kEventCreatedNotification = @"EventCreated";



NSString *const kTWOauthTokenSecretKey = @"kTWOauthTokenSecret";
NSString *const kTWOauthTokenKey = @"kTWOauthToken";
// -- Tag Dictionary keys -- //
NSString *const kTagobjId = @"tag_object_id";
NSString *const kTagobjText= @"tag_object_text";
NSString *const kTagobjType = @"tag_object_type";

NSString *const kBulletUnicode = @"\u2022";

@end
