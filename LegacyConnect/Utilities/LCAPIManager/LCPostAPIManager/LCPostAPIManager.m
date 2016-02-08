//
//  LCPostAPIManager.m
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCPostAPIManager.h"
#import "LCWebServiceManager.h"
#import "LCImage.h"

@implementation LCPostAPIManager

+ (void)createNewPost:(LCFeed*)post withImage:(UIImage*)image withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *imageName = @"image";
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostURL];
  
  NSError *error = nil;
  NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:post error:&error];
  
  NSMutableDictionary *dict_mut = [[NSMutableDictionary alloc] initWithDictionary:dict];
  NSArray *tags = [dict_mut objectForKey:@"postTags"];
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tags options:NSJSONWritingPrettyPrinted error:&error];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  dict_mut[@"postTags"] = jsonString;
  
  NSMutableArray *images = [[NSMutableArray alloc] init];
  LCImage *postImage;
  if(image)
  {
    postImage = [[LCImage alloc] init];
    postImage.image = image;
    postImage.imageKey= imageName;
    [images addObject:postImage];
  }
  
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict_mut andImagesArray:images withSuccess:^(id response) {
    LCDLog(@"---%@",response[kResponseMessage]);
    NSError *error = nil;
    if(error)
    {
      failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
    }
    else
    {
      LCDLog(@"Successfully created new post");
      [LCNotificationManager postCreateNewPostNotificationfromResponse:response];
      success(response);
    }
  } andFailure:^(NSString *error) {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
    failure(error);
  }];
}

+ (void)updatePost:(LCFeed*)post withImage:(UIImage*)image withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  
  NSString *imageName = @"image";
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostEditURL];
  
  NSError *error = nil;
  NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:post error:&error];
  //the tag array of dictionary is formatted json the AFNetworking not handling this as per the current assumption
  NSMutableDictionary *dict_mut = [[NSMutableDictionary alloc] initWithDictionary:dict];
  NSArray *tags = [dict_mut objectForKey:@"postTags"];
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tags options:NSJSONWritingPrettyPrinted error:&error];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  dict_mut[@"postTags"] = jsonString;
  
  NSMutableArray *images = [[NSMutableArray alloc] init];
  LCImage *postImage;
  if(image)
  {
    postImage = [[LCImage alloc] init];
    postImage.image = image;
    postImage.imageKey= imageName;
    [images addObject:postImage];
  }
  
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict_mut andImagesArray:images withSuccess:^(id response) {
    LCDLog(@"%@",response[kResponseMessage]);
    NSError *error = nil;
    if(error)
    {
      failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
    }
    else
    {
      NSError *error_1 = nil;
      LCDLog(@"Successfully updated post");
      NSDictionary *data_dic= response[kResponseData];
      NSDictionary *data_post= data_dic[@"post"];
      LCFeed *updated_post = [MTLJSONAdapter modelOfClass:[LCFeed class] fromJSONDictionary:data_post error:&error_1];
      [LCNotificationManager postPostEditedNotificationForPost:updated_post];
      success(response);
    }
  } andFailure:^(NSString *error) {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
    failure(error);
  }];
}

+ (void)deletePost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostURL];
  NSDictionary *dict = @{kPostIDKey: post.entityID};
  
  [webService performDeleteOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Post deleted");
     [LCNotificationManager postPostDeletedNotificationforPost:post];
     success(response);
     //Notify Profile
     
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)makePostAsMilestone:(NSString *)postId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostMilestoneURL];
  NSDictionary *dict = @{kPostIDKey: postId};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Marked as milestone.");
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)removeMilestoneFromPost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kPostMilestoneURL,post.entityID];
  
  [webService performDeleteOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     LCDLog(@"Removed milestone.");
     [LCNotificationManager postRemoveMilestoneNotificationForPost:post];
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
  
}

+ (void)reportPostWithPostId:(LCFeed*)feedObj withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetReportPostURL];
  NSDictionary *dict = @{kPostIDKey: feedObj.entityID};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     LCDLog(@"Reported post successfully.");
     [LCNotificationManager postPostReportedNotificationforPost:feedObj];
     success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

@end
