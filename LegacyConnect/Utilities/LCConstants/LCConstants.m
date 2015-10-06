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
#define CURRENT_SERVER QA_SERVER


#if CURRENT_SERVER == QA_SERVER
/* QA url */
NSString *const kBaseURL = @"http://10.3.0.55:8000/";

#elif CURRENT_SERVER == DEV_SERVER
///* Development url */
NSString *const kBaseURL = @"http://dev.legacyconnect.com/";

#elif CURRENT_SERVER == STAGING_SERVER
///* Staging url */
NSString *const kBaseURL = @"https://staging.legacyconnect.com/";

#endif


NSString *const kLoginURL = @"api/login";
NSString *const kRegisterURL = @"api/user";
NSString *const kEditProfileURL = @"api/user/edit";
NSString *const kFBLoginURL = @"api/user/fbLogin";
NSString *const kUploadUserImageURL = @"api/user/profileImage";
NSString *const kGetInterestsURL = @"api/interests";
NSString *const kGetCausesURL = @"api/causes";
NSString *const kSaveIneterestsURL = @"api/user/interests";
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

NSString *const kMainStoryBoardIdentifier = @"Main";
NSString *const kSignupStoryBoardIdentifier = @"SignUp";
NSString *const kProfileStoryBoardIdentifier = @"Profile";
NSString *const kInterestsStoryBoardIdentifier = @"Interests";
NSString *const kCommunityStoryBoardIdentifier = @"Community";
NSString *const kNotificationStoryBoardIdentifier = @"Notification";
NSString *const kCreatePostStoryBoardIdentifier = @"CreatePost";

NSString *const kHomeFeedsStoryBoardID = @"LCFeedsHomeViewController";
NSString *const kChooseCommunityStoryBoardID = @"LCChooseCommunityInterest";
NSString *const kUpdatePasswordStoryBoardID = @"LCUpdatePasswordViewController";
NSString *const kLoginStoryBoardID = @"LCLoginViewController";
NSString *const kForgotPasswordStoryBoardID = @"LCForgotPasswordViewController";

NSString *const kAuthorizationKey = @"Authorization";
NSString *const kResponseCode = @"status";
NSString *const kResponseMessage = @"message";
NSString *const kResponseData = @"data";
NSString *const kInterestsKey = @"interests";
NSString *const kCausesKey = @"causes";
NSString *const kInterestIDKey = @"interestId";
NSString *const kEventIDKey = @"eventId";
NSString *const kLastCauseIDKey = @"lastCauseId";
NSString *const kFriendsKey = @"friends";
NSString *const kFriendIDKey = @"friendId";
NSString *const kFeedsKey = @"feeds";
NSString *const kMileStonesKey = @"milestones";

NSString *const kLoginStatusKey = @"logged_in";
NSString *const kUserTokenKey = @"user_token";


NSString *const kStatusCodeSuccess = @"success";
NSString *const kStatusCodeFailure = @"failure";

NSString *const kIDKey = @"id";
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

NSString *const kFeedCellActionLike = @"feedCellLike";
NSString *const kFeedCellActionComment = @"feedCellComment";
NSString *const kFeedCellActionMore = @"feedCellmore";
NSString *const kFeedCellActionImage = @"feedCellImage";

NSString *const kFeedTagTypeCause = @"cause";
NSString *const kFeedTagTypeUser = @"user";

NSString *const kLCUrlScheme = @"legacyconnect";
NSString *const kResetPasswordTokenKey = @"password_reset_token";
NSString *const kResetPasswordNotificationName = @"password_reset_notification";

NSString *const kUserDataUpdatedNotification = @"user_data_updated_notification";

@end
