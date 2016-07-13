//
//  LCOnboardingAPIManager.m
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardingAPIManager.h"
#import "LCWebServiceManager.h"
#import "LCImage.h"

@implementation LCOnboardingAPIManager

+ (void)registerNewUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kRegisterURL];
  [webService performPostOperationWithUrl:url andAccessToken:kEmptyStringValue withParameters:params withSuccess:^(id response)
   {
     LCDLog(@"%@",response[kResponseMessage]);
     NSError *error = nil;
     LCUserDetail *user = [MTLJSONAdapter modelOfClass:[LCUserDetail class] fromJSONDictionary:response[kResponseData] error:&error];
     if(error)
     {
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Successfully registered new user");
       success(user);
     }
   } andFailure:^(NSString *error){
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)performOnlineFBLoginRequest:(NSArray*)parameters withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:parameters forKeys:@[kEmailKey,kFirstNameKey, kLastNameKey, kDobKey, kFBUserIDKey, kFBAccessTokenKey, kFBAvatarImageUrlKey]];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kFBLoginURL];
  [webService performPostOperationWithUrl:url andAccessToken:kEmptyStringValue withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"%@",response);
     NSDictionary *responseData = response[kResponseData];
     [LCDataManager sharedDataManager].avatarUrl = responseData[kFBAvatarImageUrlKey];
     [LCDataManager sharedDataManager].userID = responseData[kUserIDKey];
     [LCDataManager sharedDataManager].userToken = responseData[kAccessTokenKey];
     success(responseData);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     failure(error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
   }];
}

+ (void)uploadImage:(UIImage *)image ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSDictionary *parameters = @{kUserIDKey: userID};
  NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseURL,kUploadUserImageURL];
  LCImage *imageModel = [[LCImage alloc] init];
  imageModel.imageKey = @"image";
  imageModel.image = image;
  
  NSMutableArray *imagesArray = [[NSMutableArray alloc] initWithArray:@[imageModel]];
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:urlString accessToken:[LCDataManager sharedDataManager].userToken parameters:parameters andImagesArray:imagesArray withSuccess:^(id response)
   {
     LCDLog(@"Image upload success!");
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)performLoginForUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kLoginURL];
  [webService performPostOperationWithUrl:url  andAccessToken:kEmptyStringValue withParameters:params withSuccess:^(id response)
   {
     NSError *error = nil;
     if(error)
     {
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Login success ! ");
       success(response);//passing response directly to get the firsttimelogin user parameter
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     failure(error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
   }];
}

+ (void)forgotPasswordOfUserWithMailID:(NSString *)emailID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kForgotPasswordURL];
  NSDictionary *dict = @{kEmailKey:emailID};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Email request sent! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)resetPasswordWithPasswordResetCode:(NSString *)PasswordResetCode andNewPassword:(NSString*) password withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdatePasswordURL];
  NSDictionary *dict = @{kPasswordResetCode:PasswordResetCode, kPasswordKey:password};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Password updated! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)checkIfNewUser:(NSString*)emailID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, @"api/user/exists"];
  NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:emailID,@"email", nil];
  [webService performPostOperationWithUrl:url andAccessToken:kEmptyStringValue withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"%@",response[kResponseMessage]);
     success(response[kResponseData]);
    } andFailure:^(NSString *error){
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}



@end
