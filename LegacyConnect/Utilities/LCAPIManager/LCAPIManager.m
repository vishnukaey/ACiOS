
//
//  LCAPIManager.m
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCAPIManager.h"
#import "LCWebServiceManager.h"
#import "LCImage.h"

static LCAPIManager *sharedManager = nil;
@implementation LCAPIManager


#pragma mark - Feeds and Notifications

+ (void)getUserDetailsOfUser:(NSString*)userID WithSuccess:(void (^)(LCUserDetail* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kRegisterURL,userID];
  [webService performGetOperationWithUrl:url andAccessToken:[[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey] withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       LCUserDetail *user = [MTLJSONAdapter modelOfClass:[LCUserDetail class] fromJSONDictionary:response[kResponseData] error:&error];
       if(!error)
       {
         LCDLog(@"User details Fetch success!");
         success(user);
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
       if(!error)
       {
         LCDLog(@"Fetching Home Feeds successful! ");
         success(responsesArray);
       }
       else
       {
         failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
       }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)getMilestonesForUser:(NSString *)userID andLastMilestoneID:(NSString*)lastID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL, kGetMilestonesURL, kUserIDKey, userID];
  if (lastID) {
    url = [NSString stringWithFormat:@"%@&lastId=%@",url,lastID];
  }
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCFeed class] fromJSONArray:dict[kMileStonesKey] error:&error];
       if(!error)
       {
         LCDLog(@"Milestones fetch success! ");
         success(responsesArray);
       }
       else
       {
         failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
       }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)getImpactsForUser:(NSString *)userID andLastImpactsID:(NSString*)lastID with:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL, kGetImpactsURL, kUserIDKey,userID];
  if (lastID) {
    url = [NSString stringWithFormat:@"%@&lastId=%@",url,lastID];
  }
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCFeed class] fromJSONArray:dict[kImpactsKey] error:&error];
       if(!error)
       {
         LCDLog(@"Impacts fetch success! ");
         success(responsesArray);
       }
       else
       {
         failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
       }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)searchForItem:(NSString*)searchItem withSuccess:(void (^)(LCSearchResult* searchResult))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL,@"api/search",@"searchKey",searchItem];
  url = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
  
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       LCSearchResult *searchresult = [MTLJSONAdapter modelOfClass:[LCSearchResult class] fromJSONDictionary:dict error:&error];
       if(!error)
       {
         LCDLog(@"Search success! ");
         success(searchresult);
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



+ (void)searchUserUsingsearchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure
{
  
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@/?", kBaseURL, @"api/search/user"];
  if (searchKey) {
    [url appendString:[NSString stringWithFormat:@"&searchKey=%@",searchKey]];
  }
  if (lastUserId) {
    [url appendString:[NSString stringWithFormat:@"&lastId=%@",lastUserId]];
  }
  url = [[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] mutableCopy];
  
  [webService performGetOperationWithUrl:(NSString*)url andAccessToken:userToken withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCUserDetail class] fromJSONArray:response[kResponseData] error:&error];
       if(!error)
       {
         LCDLog(@"Getting Friends successful! ");
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


+ (void)getRequestNotificationsWithLastUserId:(NSString*)lastId withSuccess:(void (^)(NSArray* responses))success andfailure:(void (^)(NSString *error))failure
{
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",kBaseURL,@"api/user/requests"];
  if (lastId)
  {
    [url appendString:[NSString stringWithFormat:@"&%@=%@", kLastIdKey, lastId]];
  }
  
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performGetOperationWithUrl:(NSString*)url andAccessToken:userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary * dict = response[kResponseData];
     NSArray *requests = [MTLJSONAdapter modelsOfClass:[LCRequest class] fromJSONArray:dict[@"invites"] error:&error];
     if(!error)
     {
       LCDLog(@"Post details Fetch success!");
       success(requests);
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


+ (void)updateProfile:(LCUserDetail*)user havingHeaderPhoto:(UIImage*)headerPhoto removedState:(BOOL) headerPhotoState andAvtarImage:(UIImage*)avtarImage removedState:(BOOL)avtarImageState withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kEditProfileURL];
  NSError *error = nil;
  NSDictionary *tempDict = [MTLJSONAdapter JSONDictionaryFromModel:user error:&error];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:tempDict];

  [dict setValue:[LCUtilityManager getStringValueOfBOOL:avtarImageState] forKey:@"removeAvatar"];
  [dict setValue:[LCUtilityManager getStringValueOfBOOL:headerPhotoState] forKey:@"removeHeader"];
  if(error)
  {
    LCDLog(@"%@",[error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
  }
  
  NSMutableArray *images = [[NSMutableArray alloc] init];
  LCImage *headPhotoImage;
  if(headerPhoto)
  {
    headPhotoImage = [[LCImage alloc] init];
    headPhotoImage.image = headerPhoto;
    headPhotoImage.imageKey= @"headphoto";
    [images addObject:headPhotoImage];
  }
  
  LCImage *avtarPhotoImage;
  if(avtarImage)
  {
    avtarPhotoImage = [[LCImage alloc] init];
    avtarPhotoImage.image = avtarImage;
    avtarPhotoImage.imageKey= @"avatarUrl";
    [images addObject:avtarPhotoImage];
  }
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict andImagesArray:images withSuccess:^(id response) {
    LCDLog(@"Success!");
    
    //GA Tracking
    [LCGAManager ga_trackEventWithCategory:@"Profile" action:@"Profile updated" andLabel:@"User profile updated"];

    success(response);
  } andFailure:^(NSString *error) {
    LCDLog(@"Failure");
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
    failure(error);
  }];
}

#pragma mark - Post

+ (void)getPostDetailsOfPost:(NSString*)postID WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kPostURL,postID];
  [webService performGetOperationWithUrl:url andAccessToken:[[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey] withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       LCFeed *feed = [MTLJSONAdapter modelOfClass:[LCFeed class] fromJSONDictionary:response[kResponseData] error:&error];
       if(!error)
       {
         LCDLog(@"Post details Fetch success! ");
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
  [dict_mut setObject:jsonString forKey:@"postTags"];
  
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
      if(!error)
      {
        LCDLog(@"Successfully created new post");
        [LCNotificationManager postCreateNewPostNotificationfromResponse:response];
        success(response);
      }
      else
      {
        failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
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
  [dict_mut setObject:jsonString forKey:@"postTags"];
  
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
      if(!error)
      {
        NSError *error_1 = nil;
        LCDLog(@"Successfully updated post");
        NSDictionary *data_dic= response[kResponseData];
        NSDictionary *data_post= data_dic[@"post"];
        LCFeed *updated_post = [MTLJSONAdapter modelOfClass:[LCFeed class] fromJSONDictionary:data_post error:&error_1];
        [LCNotificationManager postPostEditedNotificationForPost:updated_post];
        success(response);
      }
      else
      {
        failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
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

       if(!error)
       {
         [LCNotificationManager postCommentedNotificationforPost:post andComment:comment];
         success(comment);
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


+ (void)deleteCommentWithId:(NSString *)commentId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostCommentURL];
  NSDictionary *dict = @{kPostCommentIdKey: commentId};
  
  [webService performDeleteOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       LCDLog(@"comment deleted.");
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
       BOOL isMorePresent = [[comments objectForKey:@"more"] boolValue];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCComment class] fromJSONArray:comments[kPostCommentsKey] error:&error];
       if(!error)
       {
         LCDLog(@"Getting Comments successful! ");
         success(responsesArray,isMorePresent);
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
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kPostMilestoneURL];
  NSDictionary *dict = @{kPostIDKey: post.entityID};
  
  [webService performDeleteOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
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

#pragma mark - Interests and Causes
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

+ (void)getInterestsForUser:(NSString*)userID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL, kGetUserInterestsURL, kUserIDKey, userID];
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


+ (void)getMembersForEventID:(NSString*)eventID andLastEventID:(NSString*)lastEventID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *params = [NSString stringWithFormat:@"?%@=%@&%@=%@",kEventIDKey,eventID,@"lastUserId",lastEventID];
  NSString *url = [NSString stringWithFormat:@"%@%@%@", kBaseURL, @"api/event/users",params];
  
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCUserDetail class] fromJSONArray:dict[@"eventMembers"] error:&error];
       if(!error)
       {
         LCDLog(@"Getting Users successful! ");
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



+ (void)getUserInterestsAndCausesWithSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetInterestsAndCausesURL];
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


+ (void)getCausesForUser:(NSString*)userID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL, kGetUserCausesURL, kUserIDKey,userID];
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

+ (void)getInterestDetailsOfInterest:(NSString*)interestId WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kGetInterestURL,interestId];
  [webService performGetOperationWithUrl:url andAccessToken:[[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey] withParameters:nil withSuccess:^(id response)
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
  [webService performGetOperationWithUrl:url andAccessToken:[[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey] withParameters:nil withSuccess:^(id response)
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



#pragma mark - Friends and Requests

+ (void)getFriendsForUser:(NSString*)userId searchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success
               andfailure:(void (^)(NSString *error))failure
{  
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@?", kBaseURL, kFriendsURL];
  if (userId) {
    [url appendString:[NSString stringWithFormat:@"userId=%@",userId]];
  }
  if (searchKey) {
    [url appendString:[NSString stringWithFormat:@"&searchKey=%@",searchKey]];
  }
  if (lastUserId) {
    [url appendString:[NSString stringWithFormat:@"&lastUserId=%@",lastUserId]];
  }
  url = [[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] mutableCopy];
  
  [webService performGetOperationWithUrl:(NSString*)url andAccessToken:userToken withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       NSDictionary *friendsDict= dict[kFriendsKey];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCFriend class] fromJSONArray:friendsDict[@"users"] error:&error];
       if(!error)
       {
         LCDLog(@"Getting Friends successful! ");
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


+ (void)sendFriendRequest:(NSString *)friendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kFriendsURL];
  NSDictionary *dict = @{kFriendIDKey: friendID};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       LCDLog(@"Friend request sent %@",response);
      [LCNotificationManager postSendFriendRequestNotification:friendID forFriendStatus:kRequestWaiting];
       success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)cancelFriendRequest:(NSString *)friendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kCancelFriendURL];
  NSDictionary *dict = @{kFriendIDKey: friendID};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       LCDLog(@"Friend request cancelled \n %@",response);
     [LCNotificationManager postCancelFriendRequestNotification:friendID forFriendStatus:kNonFriend];
       success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
  
}

+ (void)removeFriend:(NSString *)FriendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kFriendsURL];
  NSDictionary *dict = @{kFriendIDKey: FriendID};

  [webService performDeleteOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       LCDLog(@"Friend request sent %@",response);
       success(response);
     [LCNotificationManager postRemoveFriendNotification:FriendID forFriendStatus:kNonFriend];
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)acceptFriendRequest:(NSString *)friendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kAcceptFriendURL];
  NSDictionary *dict = @{kFriendIDKey: friendID};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       LCDLog(@"Accept Friend request success! \n %@",response);
     [LCNotificationManager postAcceptFriendRequestNotification:friendID forFriendStatus:kIsFriend];
       success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)rejectFriendRequest:(NSString *)friendID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kRejectFriendURL];
  NSDictionary *dict = @{kFriendIDKey: friendID};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       LCDLog(@"Reject friend request success ! \n%@",response);
       success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)sendFriendRequestFromContacts:(NSArray *)emailList withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kContactFriendsURL];
  NSDictionary *dict = @{kContactEmailsKey: emailList};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       LCDLog(@"Contacts emails sent %@",response);
       success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)sendFriendRequestToFBFriends:(NSArray *)FBIDs withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kFBContactFriendsURL];
  NSDictionary *dict = @{kFBIDsKey: FBIDs};
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       LCDLog(@"Contacts IDs sent %@",response);
       success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


#pragma mark - Events

+ (void)getUserEventsForUserId:(NSString*)userId andLastEventId:(NSString*)lastEventId
                    withSuccess:(void(^)(NSArray *response))success andFailure:(void(^)(NSString* error))failure
{
  LCWebServiceManager * webService = [[LCWebServiceManager alloc] init];
  NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@%@/?",kBaseURL,kGetUserEventsURL];
  if (userId) {
    [urlString appendString:[NSString stringWithFormat:@"userId=%@",userId]];
  }
  if (lastEventId) {
    [urlString appendString:[NSString stringWithFormat:@"&lastId=%@",lastEventId]];
  }
  NSString * finalString = (NSString*)urlString;
  finalString = [finalString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [webService performGetOperationWithUrl:finalString andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
  {
      NSError *error = nil;
      NSDictionary *dict= response[kResponseData];
      NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCEvent class] fromJSONArray:dict[@"events"] error:&error];
      if(!error)
      {
        LCDLog(@"Getting Events successful! ");
        success(responsesArray);
      }
      else
      {
        failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
      }
  } andFailure:^(NSString *error) {
    LCDLog(@"%@",error);
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
       BOOL isMorePresent = [[comments objectForKey:@"more"] boolValue];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCComment class] fromJSONArray:comments[kPostCommentsKey] error:&error];
       if(!error)
       {
         LCDLog(@"Getting Comments successful! ");
         success(responsesArray,isMorePresent);
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



+ (void)getEventDetailsForEventWithID:(NSString*)eventID withSuccess:(void (^)(LCEvent* responses))success andFailure:(void (^)(NSString *error))failure{
  
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", kBaseURL,kEventsURL,eventID];
  urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [webService performGetOperationWithUrl:urlString andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       NSDictionary *dict = response[kResponseData];
       LCEvent *event = [MTLJSONAdapter modelOfClass:[LCEvent class] fromJSONDictionary:dict[@"event"] error:&error];
       if(!error)
       {
         LCDLog(@"Getting Event details successful! ");
         success(event);
       }
       else
       {
         failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
       }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


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
       [LCNotificationManager postEventCreatedNotificationWithEvent:event andResponse:response];
         LCDLog(@"Getting Event details successful! ");
       success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
  
}

+ (void)postCommentToEvent:(NSString *)eventID comment:(NSString*)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, @"api/event/comment"];
  NSDictionary *dict = @{@"eventId": eventID, kPostCommentKey:comment};
  
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       LCComment *comment = [MTLJSONAdapter modelOfClass:[LCComment class] fromJSONDictionary:dict error:&error];
       
       if(!error)
       {
         success(comment);
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


+ (void)getListOfEventsForInterestID:(NSString*)InterestID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *params = [NSString stringWithFormat:@"?%@=%@",kInterestIDKey,InterestID];
  NSString *url = [NSString stringWithFormat:@"%@%@%@", kBaseURL, kEventsURL,params];
  
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCEvent class] fromJSONArray:dict[kEventsKey] error:&error];
       if(!error)
       {
         LCDLog(@"Getting events success! ");
         success(responsesArray);
       }
       else
       {
         failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
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
       if(!error)
       {
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


#pragma mark - Registration

+ (void)performLoginForUser:(NSDictionary*)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kLoginURL];
  [webService performPostOperationWithUrl:url  andAccessToken:kEmptyStringValue withParameters:params withSuccess:^(id response)
   {
       NSError *error = nil;
       LCUserDetail *user = [MTLJSONAdapter modelOfClass:[LCUserDetail class] fromJSONDictionary:response[kResponseData] error:&error];
       if(!error)
       {
         LCDLog(@"Login success ! ");
         success(user);
       }
       else
       {
         failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
       }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     failure(error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
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
       success(response);
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
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
       LCDLog(@"%@",response[kResponseMessage]);
       NSError *error = nil;
       LCUserDetail *user = [MTLJSONAdapter modelOfClass:[LCUserDetail class] fromJSONDictionary:response[kResponseData] error:&error];
       if(!error)
       {
         LCDLog(@"Successfully registered new user");
         success(user);
       }
       else
       {
         failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
       }
   } andFailure:^(NSString *error){
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
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
  NSDictionary *dict = @{kPasswordResetCodeKey:PasswordResetCode, kPasswordKey:password};
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
    if(!error)
    {
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

#pragma mark - Settings
+ (void)getSettignsOfUserWithSuccess:(void (^)(LCSettings * responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetSettignsURL];
  [webService performGetOperationWithUrl:url andAccessToken:[[NSUserDefaults standardUserDefaults] valueForKey:kUserTokenKey] withParameters:nil withSuccess:^(id response)
   {
       NSError *error = nil;
       LCSettings *settings = [MTLJSONAdapter modelOfClass:[LCSettings class] fromJSONDictionary:response[kResponseData][@"settings"] error:&error];
       if(!error)
       {
         LCDLog(@"user settigns Fetch success!");
         success(settings);
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


@end