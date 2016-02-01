//
//  LCUserProfileAPIManager.m
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCUserProfileAPIManager.h"
#import "LCWebServiceManager.h"
#import "LCImage.h"

@implementation LCUserProfileAPIManager

#pragma mark - Feeds and Notifications

+ (void)getUserDetailsOfUser:(NSString*)userID WithSuccess:(void (^)(LCUserDetail* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, kRegisterURL,userID];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     LCUserDetail *user = [MTLJSONAdapter modelOfClass:[LCUserDetail class] fromJSONDictionary:response[kResponseData] error:&error];
     if(error)
     {
       [LCUtilityManager showAlertViewWithTitle:nil andMessage:error.localizedDescription];
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"User details Fetch success!");
       success(user);
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
     if(error)
     {
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Milestones fetch success! ");
       success(responsesArray);
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
     if(error)
     {
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Impacts fetch success! ");
       success(responsesArray);
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
  
  NSMutableArray *images = [self getUserImagesArrayWithHeaderPhoto:headerPhoto andAvatarImage:avtarImage];
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url accessToken:[LCDataManager sharedDataManager].userToken parameters:dict andImagesArray:images withSuccess:^(id response) {
    LCDLog(@"Success!");
    //GA Tracking
    [LCGAManager ga_trackEventWithCategory:@"Profile" action:@"Profile updated" andLabel:@"User profile updated"];
    
    NSError *error = nil;
    LCUserDetail *user = [MTLJSONAdapter modelOfClass:[LCUserDetail class] fromJSONDictionary:response[kResponseData] error:&error];
    if(error)
    {
      LCDLog(@"Error-- %@",error);
    }
    else{
      [LCNotificationManager postProfileUpdatedNotification:user];
    }
    
    success(response);
  } andFailure:^(NSString *error) {
    LCDLog(@"Failure");
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
    failure(error);
  }];
}

+ (NSMutableArray*)getUserImagesArrayWithHeaderPhoto:(UIImage*)headerPhoto andAvatarImage:(UIImage*)avtarImage
{
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
  return images;
}

+ (void)getInterestsForUser:(NSString*)userID lastId:(NSString*)lastId withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL, kGetUserInterestsURL, kUserIDKey, userID];
  if (lastId) {
    url = [NSString stringWithFormat:@"%@&lastId=%@",url,lastId];
  }
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCInterest class] fromJSONArray:dict[kInterestsKey] error:&error];
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

+ (void)getCausesForUser:(NSString*)userID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@?%@=%@", kBaseURL, kGetUserCausesURL, kUserIDKey,userID];
  [webService performGetOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:nil withSuccess:^(id response)
   {
     NSError *error = nil;
     NSDictionary *dict= response[kResponseData];
     NSArray *responsesArray = [MTLJSONAdapter modelsOfClass:[LCCause class] fromJSONArray:dict[kCausesKey] error:&error];
     if(error)
     {
       LCDLog(@"%@",error);
       failure([error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey]);
     }
     else
     {
       LCDLog(@"Getting Causes successful! ");
       success(responsesArray);
     }
   } andFailure:^(NSString *error) {
     LCDLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}


+ (void)blockUserWithUserID:(NSString*)userID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kBlockUserURL];
  NSDictionary *dict;
  if(userID)
  {
    dict = @{kUserIDKey:userID};
  }
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  [webService performPostOperationWithUrl:url andAccessToken:[LCDataManager sharedDataManager].userToken withParameters:dict withSuccess:^(id response) {
    LCDLog(@"Success!");
    [LCNotificationManager postBlockedUserNotification:userID forFriendStatus:kNonFriend];
    success(response[kResponseData]);
  } andFailure:^(NSString *error) {
    LCDLog(@"Failure");
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
    failure(error);
  }];
}

@end
