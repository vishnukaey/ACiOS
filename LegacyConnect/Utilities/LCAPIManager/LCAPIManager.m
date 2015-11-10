
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}



+ (void)searchUserUsingsearchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure
{
  //  userId = @"7143";
  //  NSString * userToken = @"22bcbe1caa29cb599b8f2b9f42671e1c79082eba2da606a0c28220eb4977aab2e87f7ae02b2dcf7a3daac5b7719c060b";
  
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
  
  NSMutableArray *images = [[NSMutableArray alloc] init];
  LCImage *postImage;
  if(image)
  {
    postImage = [[LCImage alloc] init];
    postImage.image = image;
    postImage.imageKey= imageName;
    [images addObject:postImage];
  }
  
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict andImagesArray:images withSuccess:^(id response) {
    if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
    {
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
      failure(response[kResponseMessage]);
    }
    else
    {
      LCDLog(@"---%@",response[kResponseMessage]);
      NSError *error = nil;
      if(!error)
      {
        LCDLog(@"Successfully created new post");
        success(response);
      }
      else
      {
        failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
      }
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
  
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict andImagesArray:images withSuccess:^(id response) {
    if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
    {
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
      failure(response[kResponseMessage]);
    }
    else
    {
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Post deleted");
       [LCNotificationManager postPostDeletedNotificationforPost:post];
       success(response);
       //Notify Profile
       
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Post liked.");
       [LCNotificationManager postLikedNotificationfromResponse:response forPost:post];
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Post unliked.");
       [LCNotificationManager postUnLikedNotificationfromResponse:response forPost:post];
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       NSError *error = nil;
       NSDictionary *dict= response[kResponseData];
       LCComment *comment = [MTLJSONAdapter modelOfClass:[LCComment class] fromJSONDictionary:dict[@"comment"] error:&error];

       if(!error)
       {
         [LCNotificationManager postCommentedNotificationforPost:post];
         success(comment);
       }
       else
       {
         LCDLog(@"%@",error);
         failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
       }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"comment deleted.");
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Marked as milestone.");
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Removed milestone.");
       [LCNotificationManager postRemoveMilestoneNotificationForPost:post];
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Save Causes Success! \n %@",response);
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Interest followed successfully");
       success(response);
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Interest unfollowed successfully");
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Cause Supported successfully");
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Cause Unsupported successfully");
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
//  userId = @"7143";
//  NSString * userToken = @"22bcbe1caa29cb599b8f2b9f42671e1c79082eba2da606a0c28220eb4977aab2e87f7ae02b2dcf7a3daac5b7719c060b";
  
  NSString * userToken = [LCDataManager sharedDataManager].userToken;
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@/?", kBaseURL, kFriendsURL];
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Friend request sent %@",response);
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Friend request cancelled \n %@",response);
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Friend request sent %@",response);
       success(response);
       //Notify Profile
       NSDictionary *userInfo = @{@"status":@"deleted"};
       [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileFrinendsUpdateNotification object:nil userInfo:userInfo];
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Accept Friend request success! \n %@",response);
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Reject friend request success ! \n%@",response);
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Contacts emails sent %@",response);
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Contacts IDs sent %@",response);
       success(response);
     }
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
    if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
    {
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
      failure(response[kResponseMessage]);
    }
    else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
    [imagesArray addObject:headerPhoto];
  }
  NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:event error:&error];
  if(error)
  {
    LCDLog(@"%@",[error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
  }
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict andImagesArray:imagesArray withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
         LCDLog(@"Getting Event details successful! ");
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Event deleted");
       success(response);
       //Notify Profile
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Users succcesfully added to Event \n %@",response);
       success(response);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}

+ (void)updateEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, @"api/editEvent"];
  NSError *error = nil;
  NSMutableArray *imagesAray =[[NSMutableArray alloc] init];
  if (headerPhoto)
  {
    [imagesAray addObject:headerPhoto];
  }
  NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:event error:&error];
  if(error)
  {
    LCDLog(@"%@",[error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
  }
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict andImagesArray:imagesAray withSuccess:^(id response) {
    if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
    {
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
      failure(response[kResponseMessage]);
    }
    else
    {
      LCDLog(@"Event update success! %@",response);
      success(response);
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Following Event ! \n %@",response);
       event.isFollowing = YES;
       NSDictionary *dict= response[kResponseData];
       event.followerCount = dict[@"followerCount"];
       [LCNotificationManager postEventMembersCountUpdatedNotification:event];
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Unfollowing Event ! \n %@",response);
       event.isFollowing = NO;
       NSDictionary *dict= response[kResponseData];
       event.followerCount = dict[@"followerCount"];
       [LCNotificationManager postEventMembersCountUpdatedNotification:event];
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"%@",response);
       NSDictionary *responseData = response[kResponseData];
       [LCDataManager sharedDataManager].avatarUrl = responseData[kFBAvatarImageUrlKey];
       [LCDataManager sharedDataManager].userID = responseData[kUserIDKey];
       [LCDataManager sharedDataManager].userToken = responseData[kAccessTokenKey];
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
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
     }
   } andFailure:^(NSString *error){
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)uploadImage:(UIImage *)image ofUser:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSData *imageData = UIImagePNGRepresentation(image);
  NSDictionary *parameters = @{kUserIDKey: userID};
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:5.0];
  [manager.requestSerializer setValue:[LCDataManager sharedDataManager].userToken forHTTPHeaderField:kAuthorizationKey];
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
      LCDLog(@"Image upload success! \n %@",responseObject);
      success(responseObject);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      LCDLog(@"%@",error);
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:error.localizedDescription];
    failure(error.localizedDescription);
  }];
  
//  [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//    LCDLog(@"tt-->>>%f", (float)totalBytesWritten/totalBytesExpectedToWrite);
//  }];
}


+ (void)forgotPasswordOfUserWithMailID:(NSString *)emailID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kForgotPasswordURL];
  NSDictionary *dict = @{kEmailKey:emailID};
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response)
   {
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Email request sent! \n %@",response);
       success(response);
     }
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
     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
       failure(response[kResponseMessage]);
     }
     else
     {
       LCDLog(@"Password updated! \n %@",response);
       success(response);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
  
}


@end