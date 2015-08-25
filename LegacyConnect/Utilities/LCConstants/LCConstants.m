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

NSString *const kResponseCode = @"status";
NSString *const kResponseMessage = @"message";
NSString *const kResponseData = @"data";
NSString *const kInterestsKey = @"interests";
NSString *const kCausesKey = @"causes";

NSString *const kLoginStatusKey = @"logged_in";
NSString *const kUserTokenKey = @"user_token";


NSString *const kStatusCodeSuccess = @"success";
NSString *const kStatusCodeFailure = @"failure";

NSString *const kUpdatePasswordURL = @"";
NSString *const kForgotPasswordURL = @"";
NSString *const kChangePasswordURL = @"";
NSString *const kStaticTableSyncURL = @"";
NSString *const kLogOutURL = @"";

NSString *const kIDKey = @"id";
NSString *const kUserIDKey = @"userId";
NSString *const kFirstNameKey = @"firstName";
NSString *const kLastNameKey = @"lastName";
NSString *const kEmailKey = @"email";
NSString *const kAccessTokenKey = @"accessToken";
NSString *const kPasswordKey = @"password";
NSString *const kDobKey = @"dob";
NSString *const kFBUserIDKey = @"fbUid";
NSString *const kFBAvatarImageUrlKey = @"avatarUrl";
NSString *const kFBAccessTokenKey = @"fbAccessToken";
NSString *const kUserImageData = @"image";
NSString *const kUserimageExtension = @"imageExtension";

NSString *const kEmptyStringValue = @"";
NSString *const kDefaultDateFormat = @"yyyy-mm-dd";

NSString *const kHomefeedCellID = @"homefeedCell";
NSString *const kCommentsfeedCellID = @"commentfeedCell";

NSString *const kFeedCellActionLike = @"feedCellLike";
NSString *const kFeedCellActionComment = @"feedCellComment";
NSString *const kFeedCellActionImage = @"feedCellImage";

NSString *const kFeedTagTypeCause = @"cause";
NSString *const kFeedTagTypeUser = @"user";

@end
