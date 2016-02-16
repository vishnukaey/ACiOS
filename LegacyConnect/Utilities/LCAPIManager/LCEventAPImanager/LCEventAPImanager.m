//
//  LCEventAPImanager.m
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCEventAPImanager.h"
#import "LCWebServiceManager.h"
#import "LCImage.h"

@implementation LCEventAPImanager

+ (void)createEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kEventsURL];
  NSError *error = nil;
  NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
  if(headerPhoto)
  {
    LCImage *image = [[LCImage alloc] init];
    image.image = headerPhoto;
    image.imageKey = @"image";
    [imagesArray addObject:image];
  }
  NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:event error:&error];
  if(error)
  {
    LCDLog(@"%@",[error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
  }
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict andImagesArray:imagesArray withSuccess:^(id response)
   {
     [LCNotificationManager postEventCreatedNotificationWithResponse:response];
     LCDLog(@"Getting Event details successful! ");
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)updateEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto andImageStatus:(bool)status withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, @"api/editEvent"];
  NSError *error = nil;
  NSMutableArray *imagesArray =[[NSMutableArray alloc] init];
  if(headerPhoto)
  {
    LCImage *image = [[LCImage alloc] init];
    image.image = headerPhoto;
    image.imageKey = @"image";
    [imagesArray addObject:image];
  }
  NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:event error:&error];
  NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
  [tempDict setValue:[LCUtilityManager getStringValueOfBOOL:status] forKey:@"removeHeader"];
  
  if(error)
  {
    LCDLog(@"%@",[error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
  }
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:tempDict andImagesArray:imagesArray withSuccess:^(id response) {
    [LCNotificationManager postEventDetailsUpdatedNotificationWithResponse:response andEvent:event];
    LCDLog(@"Event update success! %@",response);
    success(response);
  } andFailure:^(NSString *error) {
    LCDLog(@"%@",error);
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
    failure(error);
  }];
}

+ (void)getEventDetailsForEventWithID:(NSString*)eventID withSuccess:(void (^)(LCEvent* responses))success andFailure:(void (^)(NSString *error))failure{
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", kBaseURL,kEventsURL,eventID];
  urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [webService performGetOperationWithUrl:urlString andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict = response[kResponseData];
     LCEvent *event = [MTLJSONAdapter modelOfClass:[LCEvent class] fromJSONDictionary:dict[@"event"] error:&error];
     if(error)
     {
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Getting Event details successful! ");
       success(event);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)deleteEvent:(LCEvent *)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@%@", kBaseURL, @"api/event/",event.eventID];
  
  [webService performDeleteOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     LCDLog(@"Event deleted");
     [LCNotificationManager postEventDeletedNotification:event];
     success(response);
     //Notify Profile
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)addUsersWithUserIDs:(NSArray*)userIDs forEventWithEventID:(NSString*)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kAddUsersToEventURL];
  NSDictionary *dict = @{@"users":userIDs, kEventIDKey: eventID};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Users succcesfully added to Event \n %@",response);
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getMembersForEventID:(NSString*)eventID andLastEventID:(NSString*)lastEventID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *params = [NSString stringWithFormat:@"?%@=%@&%@=%@",kEventIDKey,eventID,@"lastId",lastEventID];
  NSString *url = [NSString stringWithFormat:@"%@%@%@", kBaseURL, @"api/event/users",params];
  
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCUserDetail class] fromJSONArray:dict[@"eventMembers"] error:&error];
     if(error)
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Getting Users successful! ");
       success(responsesArray);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getMemberFriendsForEventID:(NSString*)eventID searchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure
{
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@?", kBaseURL, @"api/user/friend/event"];
  if (eventID) {
    [url appendString:[NSString stringWithFormat:@"eventId=%@",eventID]];
  }
  if (searchKey) {
    [url appendString:[NSString stringWithFormat:@"&searchKey=%@",searchKey]];
  }
  if (lastUserId) {
    [url appendString:[NSString stringWithFormat:@"&%@=%@",kLastIdKey, lastUserId]];
  }
  url = [[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] mutableCopy];
  
  [webService performGetOperationWithUrl:(NSString*)url andAccessToken:userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSArray *data= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCFriend class] fromJSONArray:data error:&error];
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

+ (void)getListOfEventsForInterestID:(NSString*)InterestID lastID:(NSString*)lastID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSMutableString *params = [NSMutableString stringWithFormat:@"?%@=%@",kInterestIDKey,InterestID];
  if (lastID) {
    [params appendString:[NSString stringWithFormat:@"&%@=%@", kLastIdKey, lastID]];
  }
  NSString *url = [NSString stringWithFormat:@"%@%@%@", kBaseURL, kEventsURL,params];
  
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCEvent class] fromJSONArray:dict[kEventsKey] error:&error];
     if(error)
     {
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Getting events success! ");
       success(responsesArray);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)followEvent:(LCEvent*)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL,kFollowEventURL];
  NSDictionary *dict = @{kEventIDKey:event.eventID};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Following Event ! \n %@",response);
     [LCNotificationManager postEventFollowedNotificationWithEvent:event andResponse:response];
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)unfollowEvent:(LCEvent*)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUnfollowEventURL];
  NSDictionary *dict = @{kEventIDKey:event.eventID};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Unfollowing Event ! \n %@",response);
     [LCNotificationManager postEventUnFollowedNotificationWithEvent:event andResponse:response];
     success(response);
   } andFailure:^(NSString *error) {
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getCommentsForEvent:(NSString*)eventID lastCommentID:(NSString*)lastID withSuccess:(void (^)(id response, BOOL isMore))success andfailure:(void (^)(NSString *error))failure
{
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@?", kBaseURL, @"api/event/comments"];
  if (eventID) {
    [url appendString:[NSString stringWithFormat:@"%@=%@", @"eventId", eventID]];
  }
  if (lastID) {
    [url appendString:[NSString stringWithFormat:@"&%@=%@", kLastIdKey, lastID]];
  }
  
  [webService performGetOperationWithUrl:(NSString*)url andAccessToken:userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSDictionary * comments = dict[kPostCommentsKey];
     BOOL isMorePresent = [comments[@"more"] boolValue];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCComment class] fromJSONArray:comments[kPostCommentsKey] error:&error];
     if(error)
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Getting Comments successful! ");
       success(responsesArray,isMorePresent);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)postCommentToEvent:(LCEvent *)event comment:(NSString*)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, @"api/event/comment"];
  NSDictionary *dict = @{@"eventId": event.eventID, kPostCommentKey:comment};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     LCComment *comment = [MTLJSONAdapter modelOfClass:[LCComment class] fromJSONDictionary:dict error:&error];
     
     if(error)
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       [LCNotificationManager postEventCommentedNotificationWithComment:comment andEvent:event];
       success(comment);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)deleteCommentFromAction:(LCEvent *)action withComment:(LCComment *)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kCommentURL,comment.commentId];
  [webService performDeleteOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     LCDLog(@"comment deleted.");
     [LCNotificationManager postEventCommenteDeletedNotificationWithComment:comment andEvent:action];
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)blockEventWithEvent:(LCEvent*)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kBlockEventURL];
  NSDictionary *dict;
  
  if(event.eventID)
  {
    dict = @{kEventIDKey:event.eventID};
  }
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response) {
    LCDLog(@"Success!");
    [LCNotificationManager postEventBlockedNotificationForEvent:event];
    success(response[kResponseData]);
  } andFailure:^(NSString *error) {
    LCDLog(@"Failure");
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
    failure(error);
  }];
}

@end
