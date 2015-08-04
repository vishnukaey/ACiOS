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


NSString *const kResponseCode = @"status";
NSString *const kResponseMessage = @"message";
NSString *const kResponseData = @"data";

NSString *const kLoginStatusKey = @"logged_in";

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

@end
