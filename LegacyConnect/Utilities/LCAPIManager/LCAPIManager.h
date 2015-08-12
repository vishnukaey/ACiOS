//
//  LCAPIManager.h
//  LegacyConnect
//
//  Created by qbuser on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAPIManager : NSObject

#pragma mark - GET API Requests

+ (void)getInterestsWithSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCausesForInterest:(NSString*)InterestID andLastCauseID:(NSString*)lastCauseID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getUserDetailsOfUser:(NSString*)userID WithSuccess:(void (^)(LCUserDetail* responses))success andFailure:(void (^)(NSString *error))failure;


#pragma mark - POST API Requests

+ (void) performLoginForUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)registerNewUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)UploadImage:(UIImage *)image ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)saveCauses:(NSArray *)causes ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

@end
