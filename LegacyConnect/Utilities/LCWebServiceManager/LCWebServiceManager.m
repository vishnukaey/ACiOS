//
//  LCWebServiceManager.m
//  LegacyConnect
//
//  Created by Vishnu on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCWebServiceManager.h"

@implementation LCWebServiceManager


- (void)performPostOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       success(responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       failure([error localizedDescription]);
     }];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"No_network_alert_msg", @"")];
  }
}


/* Un comment for GET Request */

- (void)performGetOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:urlString parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       success(responseObject);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       NSString *errorMsg = operation.responseObject[kResponseMessage];
       (!errorMsg||[errorMsg isKindOfClass:[NSNull class]] ? failure([error localizedDescription]) : failure(errorMsg));
       NSLog(@"error is %@", [error localizedDescription]);
     }];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"No_network_alert_msg", @"")];
  }
}

@end
