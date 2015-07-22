//
//  LCConstants.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCConstants : NSObject

extern NSString *const kBaseURL;
extern NSString *const kLoginURL;
extern NSString *const kRegisterURL;
extern NSString *const kUpdatePasswordURL;
extern NSString *const kForgotPasswordURL;
extern NSString *const kChangePasswordURL;
extern NSString *const kLogOutURL;

extern NSString *const kResponseCode;
extern NSString *const kResponseMessage;
extern NSString *const kResponseData;

extern NSString *const kStatusCodeSuccess;
extern NSString *const kStatusCodeFailure;

extern NSString *const kLoginStatusKey;

extern NSString *const kFirstNameKey;
extern NSString *const kLastNameKey;
extern NSString *const kEmailKey;
extern NSString *const kPasswordKey;
extern NSString *const kDobKey;

extern NSString *const kEmptyStringValue;

@end
