//
//  LCConstants.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCConstants : NSObject

extern NSString *const kTWConsumerKey;
extern NSString *const kTWConsumerSecretKey;

#ifdef DEBUG
#define LCDLog(s,...) NSLog(s, ##__VA_ARGS__)
#else
#define LCDLog(...)
#endif


extern NSString *const kBaseURL;
extern NSString *const kLoginURL;
extern NSString *const kRegisterURL;
extern NSString *const kEditProfileURL;
extern NSString *const kFBLoginURL;

extern NSString *const kGetUserDetailsURL;
extern NSString *const kGetInterestURL;
extern NSString *const kGetInterestsURL;
extern NSString *const kGetUserInterestsURL;
extern NSString *const kGetInterestFollowersURL;
extern NSString *const kIneterestsFollowURL;
extern NSString *const kIneterestsUnfollowURL;
extern NSString *const kGetInterestsAndCausesURL;

extern NSString *const kGetCauseURL;
extern NSString *const kGetCausesURL;
extern NSString *const kGetUserCausesURL;
extern NSString *const kGetCauseFollowersURL;
extern NSString *const kCauseSuppotURL;
extern NSString *const kCauseUnsuppotURL;

extern NSString *const kUploadUserImageURL;
extern NSString *const kUpdatePasswordURL;
extern NSString *const kForgotPasswordURL;
extern NSString *const kLogOutURL;
extern NSString *const kGetFeedsURL;
extern NSString *const kGetMilestonesURL;
extern NSString *const kGetImpactsURL;
extern NSString *const kGetUserEventsURL;
extern NSString *const kFriendsURL;
extern NSString *const kEventsURL;
extern NSString *const kRejectFriendURL;
extern NSString *const kAcceptFriendURL;
extern NSString *const kCancelFriendURL;
extern NSString *const kUnfollowEventURL;
extern NSString *const kFollowEventURL;
extern NSString *const kAddUsersToEventURL;
extern NSString *const kContactFriendsURL;
extern NSString *const kFBContactFriendsURL;
extern NSString *const kprofileEditURL;
extern NSString *const kPostURL;
extern NSString *const kPostEditURL;
extern NSString *const kPostLikeURL;
extern NSString *const kPostUnlikeURL;
extern NSString *const kPostCommentURL;
extern NSString *const kPostCommentsURL;
extern NSString *const kPostMilestoneURL;



extern NSString *const kMainStoryBoardIdentifier;
extern NSString *const kSignupStoryBoardIdentifier;
extern NSString *const kProfileStoryBoardIdentifier;
extern NSString *const kInterestsStoryBoardIdentifier;
extern NSString *const kCommunityStoryBoardIdentifier;
extern NSString *const kNotificationStoryBoardIdentifier;
extern NSString *const kCreatePostStoryBoardIdentifier;
extern NSString *const kSettingsStoryBoardIdentifier;



extern NSString *const kHomeFeedsStoryBoardID;
extern NSString *const kChooseCommunityStoryBoardID;
extern NSString *const kUpdatePasswordStoryBoardID;
extern NSString *const kLoginStoryBoardID;
extern NSString *const kForgotPasswordStoryBoardID;
extern NSString *const kSettingsStoryBoardID;



extern NSString *const kAuthorizationKey;
extern NSString *const kResponseCode;
extern NSString *const kResponseMessage;
extern NSString *const kResponseData;
extern NSString *const kUsersKey;
extern NSString *const kInterestsKey;
extern NSString *const kCauseIDKey;
extern NSString *const kCausesKey;
extern NSString *const kInterestIDKey;
extern NSString *const kEventIDKey;
extern NSString *const kLastCauseIDKey;
extern NSString *const kFriendsKey;
extern NSString *const kFeedsKey;
extern NSString *const kFriendIDKey;
extern NSString *const kPostIDKey;
extern NSString *const kPasswordResetCodeKey;
extern NSString *const kEventsKey;
extern NSString *const kContactEmailsKey;
extern NSString *const kMileStonesKey;
extern NSString *const kImpactsKey;
extern NSString *const kPostCommentKey;
extern NSString *const kPostCommentsKey;
extern NSString *const kPostCommentIdKey;
extern NSString *const kLastIdKey;

extern NSString *const kStatusCodeSuccess;
extern NSString *const kStatusCodeFailure;

extern NSString *const kLoginStatusKey;
extern NSString *const kUserTokenKey;

extern NSString *const kIDKey;
extern NSString *const kRange;
extern NSString *const kMeKey;
extern NSString *const kUserIDKey;
extern NSString *const kFirstNameKey;
extern NSString *const kLastNameKey;
extern NSString *const kEmailKey;
extern NSString *const kFieldsKey;
extern NSString *const kPasswordKey;
extern NSString *const kDobKey;
extern NSString *const kAccessTokenKey;
extern NSString *const kFBUserIDKey;
extern NSString *const kFBIDsKey;
extern NSString *const kFBAvatarImageUrlKey;
extern NSString *const kFBAccessTokenKey;
extern NSString *const kUserImageData;
extern NSString *const kUserimageExtension;

extern NSString *const kEmptyStringValue;
extern NSString *const kDefaultDateFormat;

extern NSString *const kHomefeedCellID;
extern NSString *const kCommentsfeedCellID;

extern NSString *const kWordType;
extern NSString *const kFeedTagTypeCause;
extern NSString *const kFeedTagTypeInterest;
extern NSString *const kFeedTagTypeUser;

extern NSString *const kTwitterUrlScheme;
extern NSString *const kLCUrlScheme;
extern NSString *const kResetPasswordTokenKey;
extern NSString *const kResetPasswordNotificationName;

extern NSString *const kUserDataUpdatedNotification;
extern NSString *const kTwitterCallbackNotification;
extern NSString *const kUserProfileUpdateNotification;
extern NSString *const kUserProfileFrinendsUpdateNotification;
extern NSString *const kUserProfileImpactsUpdateNotification;
extern NSString *const kfeedUpdatedotification;
extern NSString *const kActionUpdatedotification;

extern NSString *const kfeedUpdateEventKey;
extern NSString *const kfeedDeletedEventKey;

extern NSString *const kEventMemberCountUpdatedNotification;
extern NSString *const kEventDetailsUpdatedNotification;
extern NSString *const kEventDeletedNotification;
extern NSString *const kEventCreatedNotification;

extern NSString *const kTWOauthTokenSecretKey;
extern NSString *const kTWOauthTokenKey;

extern NSString *const kTagobjId;
extern NSString *const kTagobjText;
extern NSString *const kTagobjType;

extern NSString *const kBulletUnicode;


// Settings Section //
extern NSString *const kSettingsScreenTitle;
extern NSString *const kEmailUpdateScreenTitle;

extern NSString *const kAccountTitle;
extern NSString *const kEmailAddress;
extern NSString *const kChangePassword;
extern NSString *const kMyLegacyURL;
extern NSString *const kPrivacy;
extern NSString *const kSignOut;



#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)


@end
