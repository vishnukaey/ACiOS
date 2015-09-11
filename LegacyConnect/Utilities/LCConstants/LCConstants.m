//
//  LCConstants.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCConstants.h"

@implementation LCConstants


NSString *const kBaseURL = @"http://10.3.0.55:8000";

NSString *const kLoginURL = @"/api/login";
NSString *const kRegisterURL = @"/api/user";
NSString *const kFBLoginURL = @"/api/user/fbLogin";
NSString *const kUploadUserImageURL = @"/api/user/profileImage";
NSString *const kGetUserDetailsURL =  @"/api/user/";
NSString *const kGetInterestsURL = @"/api/interests";
NSString *const kGetCausesURL = @"/api/causes";
NSString *const kSaveIneterestsURL = @"/api/user/interests";
NSString *const kGetFeedsURL = @"/api/feed";
NSString *const kFriendsURL = @"/api/user/friend";
NSString *const kEventsURL = @"/api/event";
NSString *const kRejectFriendURL = @"api/user/friend/decline";
NSString *const kAcceptFriendURL = @"api/user/friend/accept";
NSString *const kUnfollowEventURL = @"/api/event/unfollow";
NSString *const kFollowEventURL = @"/api/event/follow";
NSString *const kAddUsersToEventURL = @"/api/event/users";

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

NSString *const kLoginStatusKey = @"logged_in";
NSString *const kUserTokenKey = @"user_token";


NSString *const kStatusCodeSuccess = @"success";
NSString *const kStatusCodeFailure = @"failure";

NSString *const kForgotPasswordURL = @"/api/user/forgotPassword";
NSString *const kUpdatePasswordURL = @"/api/user/resetPassword";
NSString *const kLogOutURL = @"";

NSString *const kIDKey = @"id";
NSString *const kUserIDKey = @"userId";
NSString *const kFirstNameKey = @"firstName";
NSString *const kLastNameKey = @"lastName";
NSString *const kEmailKey = @"email";
NSString *const kEventsKey = @"events";
NSString *const kAccessTokenKey = @"accessToken";
NSString *const kPasswordKey = @"password";
NSString *const kDobKey = @"dob";
NSString *const kFBUserIDKey = @"fbUid";
NSString *const kFBAvatarImageUrlKey = @"avatarUrl";
NSString *const kFBAccessTokenKey = @"fbAccessToken";
NSString *const kUserImageData = @"image";
NSString *const kUserimageExtension = @"imageExtension";
NSString *const kPasswordResetCodeKey = @"passwordResetCode";

NSString *const kEmptyStringValue = @"";
NSString *const kDefaultDateFormat = @"yyyy-mm-dd";

NSString *const kHomefeedCellID = @"homefeedCell";
NSString *const kCommentsfeedCellID = @"commentfeedCell";

NSString *const kFeedCellActionLike = @"feedCellLike";
NSString *const kFeedCellActionComment = @"feedCellComment";
NSString *const kFeedCellActionImage = @"feedCellImage";

NSString *const kFeedTagTypeCause = @"cause";
NSString *const kFeedTagTypeUser = @"user";

NSString *const kLCUrlScheme = @"legacyconnect";
NSString *const kResetPasswordTokenKey = @"password_reset_token";
NSString *const kResetPasswordNotificationName = @"password_reset_notification";



@end
