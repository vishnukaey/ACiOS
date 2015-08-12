//
//  LCAPIManager.m
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCAPIManager.h"
#import "LCWebServiceManager.h"

static LCAPIManager *sharedManager = nil;

@implementation LCAPIManager

#pragma mark - GET API Requests

+ (void)getInterestsWithSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetInterestsURL];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCInterest class] fromJSONArray:dict[kInterestsKey] error:&error];
       success(responsesArray);
     }
   } andFailure:^(NSString *error) {
     NSLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)getCausesForInterest:(NSString*)InterestID andLastCauseID:(NSString*)lastCauseID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *params = [NSString stringWithFormat:@"?%@=%@&%@=%@",@"interestId",InterestID,@"lastCauseId",lastCauseID];
  NSString *url = [NSString stringWithFormat:@"%@%@%@", kBaseURL, kGetCausesURL,params];
  
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCCause class] fromJSONArray:dict[kCausesKey] error:&error];
       success(responsesArray);
     }
   } andFailure:^(NSString *error) {
     NSLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)getUserDetailsOfUser:(NSString*)userID WithSuccess:(void (^)(LCUserDetail* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@%@", kBaseURL, kGetUserDetailsURL,userID];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       NSError *error = nil;
       LCUserDetail *user = [MTLJSONAdapter modelOfClass:[LCUserDetail class] fromJSONDictionary:response[kResponseData] error:&error];
       success(user);
     }
   } andFailure:^(NSString *error) {
     NSLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


#pragma mark - POST API Requests


+ (void) performLoginForUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kLoginURL];
  [webService performPostOperationWithUrl:url  andAccessToken:kEmptyStringValue withParameters:params withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       success(response);
     }
     
   } andFailure:^(NSString *error) {
     NSLog(@"%@",error);
     failure(error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
   }];  
}


+ (void)registerNewUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kRegisterURL];
  [webService performPostOperationWithUrl:url andAccessToken:kEmptyStringValue withParameters:params withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       NSLog(@"%@",response);
       success(response);
     }
   } andFailure:^(NSString *error){
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)UploadImage:(UIImage *)image ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSData *imageData = UIImagePNGRepresentation(image);
  NSDictionary *parameters = @{kUserIDKey: userID};
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager.requestSerializer setValue:[LCDataManager sharedDataManager].userToken forHTTPHeaderField:@"Authorization"];
  NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseURL,kUploadUserImageURL];
  [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.png" mimeType:@"image/png"];
  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if([responseObject[kResponseCode] isEqualToString:kStatusCodeFailure])
    {
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:responseObject[kResponseMessage]];
      failure(responseObject[kResponseMessage]);
    }
    else
    {
      NSLog(@"%@",responseObject);
      success(responseObject);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error.localizedRecoverySuggestion);
  }];
}


+ (void)saveCauses:(NSArray *)causes ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kSaveIneterestsURL];
  NSError *error;
  NSArray *jsonArray = [MTLJSONAdapter JSONArrayFromModels:causes error:&error];
  NSDictionary *dict = @{kUserIDKey: userID, kCausesKey : jsonArray};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       NSLog(@"%@",response);
       success(response);
     }
   } andFailure:^(NSString *error) {
     NSLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}



@end