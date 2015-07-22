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

NSString *const kResponseCode = @"code";
NSString *const kResponseMessage = @"message";
NSString *const kResponseData = @"data";

NSString *const kLoginStatusKey = @"logged_in";

NSString *const kStatusCodeSuccess = @"200";
NSString *const kStatusCodeFailure = @"205";

NSString *const kUpdatePasswordURL = @"";
NSString *const kForgotPasswordURL = @"";
NSString *const kChangePasswordURL = @"";
NSString *const kStaticTableSyncURL = @"";
NSString *const kLogOutURL = @"";

NSString *const kFirstNameKey = @"firstName";
NSString *const kLastNameKey = @"lastName";
NSString *const kEmailKey = @"email";
NSString *const kPasswordKey = @"password";
NSString *const kDobKey = @"dob";


NSString *const kEmptyStringValue = @"";

@end
