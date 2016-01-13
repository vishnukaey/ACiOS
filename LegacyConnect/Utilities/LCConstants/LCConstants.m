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
#define DEMO_SERVER 3

/* Set server to be used */
#define CURRENT_SERVER QA_SERVER


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
NSString *const kFBAppDisplayName = @"ThatHelps";
NSString *const kFBURLScheme = @"fb535164313296078";

#elif CURRENT_SERVER == DEMO_SERVER
///* Demo url */
NSString *const kBaseURL = @"https://demo.legacyconnect.com/";
NSString *const kFBAppID = @"781451981972910";
NSString *const kFBAppDisplayName = @"LegacyConnectDev";
NSString *const kFBURLScheme = @"fb781451981972910";

#endif

NSString *const kLCiTunesLink = @"https://itunes.apple.com/in/app/instagram/id389801252?mt=8";

NSString *const kTWConsumerKey = @"JFYQnutilTD8nKw9D0Q7iwutI";
NSString *const kTWConsumerSecretKey = @"dFA57jARhKy3vhD7cV0pPToCO7gKBN3W7Kly1kqEZUFooEbCbT";

NSString *const kLegacyConnectUrl = @"www.LegacyConnect.com/";

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
NSString *const kGetInterestFeedsURL = @"api/interest/feed";
NSString *const kGetInterestsAndCausesURL = @"api/user/getUserInterestsWithCauses";
NSString *const kGetCausesWithInterestURL = @"api/causesWithInterest";

NSString *const kGetInterestsSearchURL = @"api/search/interest";
NSString *const kGetCauseSearchURL = @"api/search/cause";
NSString *const kGetCauseURL = @"api/cause";
NSString *const kGetCausesURL = @"api/causes";
NSString *const kGetUserCausesURL = @"api/user/causes";
NSString *const kGetCauseFollowersURL = @"api/cause/users";
NSString *const kCauseSuppotURL = @"api/cause/support";
NSString *const kCauseUnsuppotURL = @"api/cause/unsupport";
NSString *const kGetCauseFromInterestsURL = @"api/causesFromInterest";
NSString *const kGetThemesURL = @"api/themes";

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
NSString *const kGetNotificationCountURL = @"api/user/notificationCount";
NSString *const kGetRecentNotificationsURL = @"api/user/notification";
NSString *const kMarkNotificationAsReadURL = @"api/user/notification/read";

NSString *const kGetSettignsURL = @"api/user/settings";
NSString *const kChangeEmailURL = @"api/user/changeEmail";
NSString *const kChangePasswordURL = @"api/user/changePassword";
NSString *const kChangeLegacyurlURL = @"api/user/changeLegacyUrl";
NSString *const kChangePrivacyURL = @"api/user/changePrivacy";
NSString *const kSignOutURL = @"api/signout";

NSString *const kVersionCheckURL = @"api/version";

NSString *const kMainStoryBoardIdentifier = @"Main";
NSString *const kSignupStoryBoardIdentifier = @"SignUp";
NSString *const kProfileStoryBoardIdentifier = @"Profile";
NSString *const kInterestsStoryBoardIdentifier = @"Interests";
NSString *const kCommunityStoryBoardIdentifier = @"Actions";
NSString *const kNotificationStoryBoardIdentifier = @"Notification";
NSString *const kCreatePostStoryBoardIdentifier = @"CreatePost";
NSString *const kSettingsStoryBoardIdentifier = @"Settings";

NSString *const kTutorialPresentKey = @"tutorialPresented";

NSString *const kHomeFeedsStoryBoardID = @"LCFeedsHomeViewController";
NSString *const kChooseCommunityStoryBoardID = @"LCChooseActionsInterest";
NSString *const kUpdatePasswordStoryBoardID = @"LCUpdatePasswordViewController";
NSString *const kLoginStoryBoardID = @"LCLoginViewController";
NSString *const kForgotPasswordStoryBoardID = @"LCForgotPasswordViewController";
NSString *const kSettingsStoryBoardID = @"LCSettingsViewController";

NSString *const kStatusCodeKey = @"statusCode";
NSString *const kLCVersionKey = @"lcversion";
NSString *const kAuthorizationKey = @"Authorization";
NSString *const kResponseCode = @"status";
NSString *const kResponseMessage = @"message";
NSString *const kResponseData = @"data";
NSString *const kUsersKey = @"users";
NSString *const kInterestsKey = @"interests";
NSString *const kCausesKey = @"causes";
NSString *const kThemesKey = @"themes";
NSString *const kInterestIDKey = @"interestId";
NSString *const kCauseIDKey = @"causeId";
NSString *const kEventIDKey = @"eventId";
NSString *const kLastCauseIDKey = @"lastId";
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

NSString *const kchangeEmailKey = @"email";
NSString *const kchangePasswordKey = @"newPassword";
NSString *const kchangeLCURLKey = @"legacyUrl";
NSString *const kchangePrivacyKey = @"privacy";

NSString *const kStatusCodeSuccess = @"100";
NSString *const kStatusCodeVersionFailure = @"102";

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
NSString *const kCausesCellID = @"causesCell";

NSString *const kWordType = @"type";
NSString *const kFeedTagTypeCause = @"cause";
NSString *const kFeedTagTypeInterest = @"interest";
NSString *const kFeedTagTypeUser = @"user";

NSString *const kEntityTypePost = @"post";
NSString *const kEntityTypeEvent = @"event";
NSString *const kEntityTypeUserProfile = @"user";


NSString *const kTwitterUrlScheme = @"twitterUrlScheme";
NSString *const kLCUrlScheme = @"legacyconnect";
NSString *const kResetPasswordTokenKey = @"password_reset_token";

NSString *const kfeedUpdateEventKey = @"updated_feed";
NSString *const kfeedDeletedEventKey = @"deleted_feed";

NSString *const keventUpdateEventKey = @"updated_event";
NSString *const keventDeletedEventKey = @"deleted_event";

NSString *const kTWOauthTokenSecretKey = @"kTWOauthTokenSecret";
NSString *const kTWOauthTokenKey = @"kTWOauthToken";
// -- Tag Dictionary keys -- //
NSString *const kTagobjId = @"tag_object_id";
NSString *const kTagobjText= @"tag_object_text";
NSString *const kTagobjType = @"tag_object_type";

// Settings Section //
NSString *const kSettingsScreenTitle = @"SETTINGS";
NSString *const kEmailUpdateScreenTitle = @"EMAIL ADDRESS";

NSString *const kAccountTitle = @"ACCOUNT";
NSString *const kEmailAddress = @"Email Address";
NSString *const kChangePassword = @"Change Password";
NSString *const kMyLegacyURL = @"My Legacy URL";
NSString *const kPrivacy = @"Privacy";
NSString *const kSignOut = @"Sign Out";

NSString *const kBulletUnicode = @"\u2022";



@end
