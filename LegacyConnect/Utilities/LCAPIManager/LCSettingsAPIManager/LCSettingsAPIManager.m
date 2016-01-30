//
//  LCSettingsAPIManager.m
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSettingsAPIManager.h"
#import "LCWebServiceManager.h"

@implementation LCSettingsAPIManager

+ (void)signOutwithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kSignOutURL];
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     LCDLog(@"Signed out! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)changePrivacy:(NSString *)newPrivacy withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kChangePrivacyURL];
  NSDictionary *dict = @{kchangePrivacyKey:newPrivacy};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"privacy updated! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)changeLegacyURL:(NSString *)newURL withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kChangeLegacyurlURL];
  NSDictionary *dict = @{kchangeLCURLKey:newURL};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"legacy URL updated! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)changePassword:(NSString *)newPassword withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kChangePasswordURL];
  NSDictionary *dict = @{kchangePasswordKey:newPassword};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"password updated! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)changeEmail:(NSString *)newEmail withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kChangeEmailURL];
  NSDictionary *dict = @{kchangeEmailKey:newEmail};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"email updated! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getSettignsOfUserWithSuccess:(void (^)(LCSettings * responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetSettignsURL];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     LCSettings *settings = [MTLJSONAdapter modelOfClass:[LCSettings class] fromJSONDictionary:response[kResponseData][@"settings"] error:&error];
     if(error)
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:error.localizedDescription];
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"user settigns Fetch success!");
       success(settings);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)checkVersionWithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kVersionCheckURL];
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     LCDLog(@"version checked! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     //     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getBlockedUsersWithSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kBlockedUsersURL];
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSArray *users= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCUserDetail class] fromJSONArray:users error:&error];
     if(error)
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Getting Blocked Users uccessful! ");
       success(responsesArray);
     }

   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     failure(error);
   }];
}


@end
