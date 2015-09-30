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
    [manager.requestSerializer setTimeoutInterval:30];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
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
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"no_network_alert_msg", @"")];
  }
}



- (void)performGetOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
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
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"no_network_alert_msg", @"")];
  }
}



- (void)performPutOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params andFormDataBlock:(void (^)(id<AFMultipartFormData> formData))block withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [[NSURL URLWithString:urlString relativeToURL:manager.baseURL] absoluteString];
//    id block = ^(id<AFMultipartFormData> formData) {
//      [formData appendPartWithFileData:imageData
//                                  name:@"image"
//                              fileName:@"image"
//                              mimeType:@"image/jpeg"];
//    };
    
    NSMutableURLRequest *request = [manager.requestSerializer
                                    multipartFormRequestWithMethod:@"PUT"
                                    URLString:url
                                    parameters:params
                                    constructingBodyWithBlock:block
                                    error:nil];
    [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             failure([error localizedDescription]);
    }];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"No_network_alert_msg", @"")];
  }
}


- (void)performDeleteOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager DELETE:urlString
         parameters:params
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



@end
