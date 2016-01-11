//
//  LCNotificationsAPIManager.m
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCNotificationsAPIManager.h"
#import "LCWebServiceManager.h"

@implementation LCNotificationsAPIManager

+ (void)getNotificationCountWithStatus:(void (^)(BOOL status))status
{
  NSString * url = [NSString stringWithFormat:@"%@%@",kBaseURL,kGetNotificationCountURL];
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performGetOperationWithUrl:(NSString*)url andAccessToken:userToken withParameters:nil withSuccess:^(id response)
   {
     NSDictionary * dict = response[kResponseData][@"count"];
     [[LCDataManager sharedDataManager] setNotificationCount:dict[@"notificationCount"]];
     [[LCDataManager sharedDataManager] setRequestCount:dict[@"requestCount"]];
     status(YES);
   } andFailure:^(NSString *error) {
     status(NO);
   }];
}

+ (void)getRecentNotificationsWithLastId:(NSString*)lastId withSuccess:(void(^)(id response))success andFailure:(void(^)(NSString*error))failure
{
  NSMutableString * url = [NSMutableString stringWithFormat:@"%@%@",kBaseURL,kGetRecentNotificationsURL];
  if (lastId) {
    [url appendString:[NSString stringWithFormat:@"?lastId=%@",lastId]];
  }
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performGetOperationWithUrl:(NSString*)url andAccessToken:userToken withParameters:nil withSuccess:^(id response) {
    NSError *error = nil;
    NSArray *data= response[kResponseData];
    NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCRecentNotification class] fromJSONArray:data error:&error];
    if(error)
    {
      LCDLog(@"%@",error);
      failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
    }
    else
    {
      success(responsesArray);
    }
  } andFailure:^(NSString *error) {
    LCDLog(@"%@",error);
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
    failure(error);
  }];
}

+ (void)markNotificationAsRead:(NSString*)notificationId andStatus:(void (^)(BOOL status))status
{
  NSString * url = [NSString stringWithFormat:@"%@%@",kBaseURL,kMarkNotificationAsReadURL];
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  NSDictionary *dict = @{@"id":notificationId};
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:userToken withParameters:dict withSuccess:^(id response) {
    status(YES);
  } andFailure:^(NSString *error) {
    status(NO);
  }];
}

+ (void)getRequestNotificationsWithLastUserId:(NSString*)lastId withSuccess:(void (^)(NSArray* responses))success andfailure:(void (^)(NSString *error))failure
{
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",kBaseURL,@"api/user/requests"];
  if (lastId)
  {
    [url appendString:[NSString stringWithFormat:@"?%@=%@", kLastIdKey, lastId]];
  }
  
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performGetOperationWithUrl:(NSString*)url andAccessToken:userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary * dict = response[kResponseData];
     NSArray *requests = [MTLJSONAdapter modelsOfClass:[LCRequest class] fromJSONArray:dict[@"invites"] error:&error];
     if(error)
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:error.localizedDescription];
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Post details Fetch success!");
       success(requests);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)rejectEventRequest:(NSString *)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, @"api/event/invite/reject"];
  NSDictionary *dict = @{@"eventId": eventID};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Reject event request success ! \n%@",response);
     [LCNotificationManager postEventRejectedNotification:eventID];
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

@end
