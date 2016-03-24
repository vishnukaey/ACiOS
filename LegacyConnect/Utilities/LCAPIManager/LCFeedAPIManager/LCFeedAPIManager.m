//
//  LCFeedAPIManager.m
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCFeedAPIManager.h"
#import "LCWebServiceManager.h"

@implementation LCFeedAPIManager

+ (void)getHomeFeedsWithLastFeedId:(NSString*)lastId success:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL,kGetFeedsURL];
  if (lastId) {
    url = [NSString stringWithFormat:@"%@?lastId=%@",url,lastId];
  }
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCFeed class] fromJSONArray:dict[kFeedsKey] error:&error];
     if(error)
     {
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Fetching Home Feeds successful! ");
       success(responsesArray);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)getPostDetailsOfPost:(NSString*)postID WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kPostURL,postID];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     LCFeed *feed = [MTLJSONAdapter modelOfClass:[LCFeed class] fromJSONDictionary:response[kResponseData] error:&error];
     if(error)
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:error.localizedDescription];
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Post details Fetch success! ");
       success(feed);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)likePost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostLikeURL];
  NSDictionary *dict = @{kPostIDKey: post.entityID};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Post liked.");
     [LCNotificationManager postLikedNotificationfromResponse:response forPost:post];
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
  
}

+ (void) unlikePost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostUnlikeURL];
  NSDictionary *dict = @{kPostIDKey: post.entityID};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Post unliked.");
     [LCNotificationManager postUnLikedNotificationfromResponse:response forPost:post];
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)commentPost:(LCFeed *)post comment:(NSString*)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostCommentURL];
  NSDictionary *dict = @{kPostIDKey: post.entityID, kPostCommentKey:comment};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     LCComment *comment = [MTLJSONAdapter modelOfClass:[LCComment class] fromJSONDictionary:dict[@"comment"] error:&error];
     
     if(error)
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       [LCNotificationManager postCommentedNotificationforPost:post andComment:comment];
       success(comment);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)deleteCommentFromPost:(LCFeed *)post withComment:(LCComment *)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kCommentURL,comment.commentId];
  [webService performDeleteOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     LCDLog(@"comment deleted.");
     [LCNotificationManager postCommentDeletededNotificationforPost:post andComment:comment];
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)getCommentsForPost:(NSString*)postId lastCommentId:(NSString*)lastId withSuccess:(void (^)(id response, BOOL isMore))success andfailure:(void (^)(NSString *error))failure
{
  
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@?", kBaseURL, kPostCommentsURL];
  if (postId) {
    [url appendString:[NSString stringWithFormat:@"%@=%@", kPostIDKey, postId]];
  }
  if (lastId) {
    [url appendString:[NSString stringWithFormat:@"&%@=%@", kLastIdKey, lastId]];
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

@end
