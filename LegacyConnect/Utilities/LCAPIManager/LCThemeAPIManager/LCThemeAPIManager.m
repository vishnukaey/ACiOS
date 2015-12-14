//
//  LCThemeAPIManager.m
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCThemeAPIManager.h"
#import "LCWebServiceManager.h"

@implementation LCThemeAPIManager

+ (void)getInterestsWithSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetInterestsURL];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCInterest class] fromJSONArray:dict[kInterestsKey] error:&error];
     if(!error)
     {
       LCDLog(@"Getting Interests successful! ");
       success(responsesArray);
     }
     else
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getCausesForInterestID:(NSString*)InterestID andLastCauseID:(NSString*)lastCauseID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *params = [NSString stringWithFormat:@"?%@=%@&%@=%@",kInterestIDKey,InterestID,kLastCauseIDKey,lastCauseID];
  NSString *url = [NSString stringWithFormat:@"%@%@%@", kBaseURL, kGetCausesURL,params];
  
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCCause class] fromJSONArray:dict[kCausesKey] error:&error];
     if(!error)
     {
       LCDLog(@"Getting Causes successful! ");
       success(responsesArray);
     }
     else
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)saveCauses:(NSArray *)causes andInterests:(NSArray*)interests ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetUserInterestsURL];
  NSDictionary *dict = @{kUserIDKey: userID, kCausesKey : causes, kInterestsKey:interests};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     //GA Tracking
     [LCGAManager ga_trackEventWithCategory:@"Interests" action:@"Added" andLabel:@"User added interests"];
     
     LCDLog(@"Save Causes Success! \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getInterestDetailsOfInterest:(NSString*)interestId WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kGetInterestURL,interestId];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     LCFeed *feed = [MTLJSONAdapter modelOfClass:[LCInterest class] fromJSONDictionary:response[kResponseData] error:&error];
     if(!error)
     {
       LCDLog(@"Interest details Fetch success! ");
       success(feed);
     }
     else
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:error.localizedDescription];
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getCauseDetailsOfCause:(NSString*)causeId WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kGetCauseURL,causeId];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     LCFeed *feed = [MTLJSONAdapter modelOfClass:[LCCause class] fromJSONDictionary:response[kResponseData] error:&error];
     if(!error)
     {
       LCDLog(@"Cause details Fetch success! ");
       success(feed);
     }
     else
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:error.localizedDescription];
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)followInterest:(NSString *)interestId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kIneterestsFollowURL];
  NSDictionary *dict = @{kInterestIDKey: interestId};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Interest followed successfully");
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getInterestFolowersOfInterest:(NSString*)interestId withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL, kGetInterestFollowersURL, kInterestIDKey, interestId];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCUserDetail class] fromJSONArray:dict[kUsersKey] error:&error];
     if(!error)
     {
       LCDLog(@"Getting Interests Followers successful! ");
       success(responsesArray);
     }
     else
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)unfollowInterest:(NSString *)interestId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kIneterestsUnfollowURL];
  NSDictionary *dict = @{kInterestIDKey: interestId};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Interest unfollowed successfully");
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)supportCause:(NSString *)causeId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kCauseSuppotURL];
  NSDictionary *dict = @{kCauseIDKey: causeId};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Cause Supported successfully");
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)unsupportCause:(NSString *)causeId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kCauseUnsuppotURL];
  NSDictionary *dict = @{kCauseIDKey: causeId};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Cause Unsupported successfully");
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getCauseFolowersOfCause:(NSString*)causeId withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL, kGetCauseFollowersURL, kCauseIDKey, causeId];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCUserDetail class] fromJSONArray:dict[kUsersKey] error:&error];
     if(!error)
     {
       LCDLog(@"Getting Cause Followers successful! ");
       success(responsesArray);
     }
     else
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getCausesForSetOfInterests:(NSArray*)interests withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetCauseFromInterestsURL];
  if (interests.count > 0) {
    NSString * restOfInterestId = [interests componentsJoinedByString:@"&interestId[]="];
    url = [NSString stringWithFormat:@"%@?interestId[]=%@",url,restOfInterestId];
  }
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSArray *data= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCInterest class] fromJSONArray:data error:&error];
     if(!error)
     {
       LCDLog(@"Getting Cause Followers successful! ");
       success(responsesArray);
     }
     else
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];

}

+ (void)getInterestsForThemeId:(NSString*)themeId lastId:(NSString*)lastId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?themeId=%@", kBaseURL, kGetInterestsURL,themeId];
  if (lastId) {
    url = [NSString stringWithFormat:@"%@&lastId=%@",url,lastId];
  }
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCInterest class] fromJSONArray:dict[kInterestsKey] error:&error];
     if(!error)
     {
       LCDLog(@"Getting Interests successful! ");
       success(responsesArray);
     }
     else
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];

}

+ (void)getThemesWithLastId:(NSString*)lastId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetThemesURL];
  if (lastId) {
    url = [NSString stringWithFormat:@"%@?lastId=%@",url,lastId];
  }
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCTheme class] fromJSONArray:dict[kThemesKey] error:&error];
     if(!error)
     {
       LCDLog(@"Getting Interests successful! ");
       success(responsesArray);
     }
     else
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];

}


@end
