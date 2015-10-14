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
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
//    manager.securityPolicy.allowInvalidCertificates = YES;
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
    failure(NSLocalizedString(@"no_network_alert_msg", @""));
  }
}



- (void)performGetOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
//    manager.securityPolicy.allowInvalidCertificates = YES;
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
    failure(NSLocalizedString(@"no_network_alert_msg", @""));
  }
}

- (void)performPutOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    NSString *url = [[NSURL URLWithString:urlString relativeToURL:manager.baseURL] absoluteString];
    NSMutableURLRequest *request = [manager.requestSerializer
                                    multipartFormRequestWithMethod:@"PUT"
                                    URLString:url
                                    parameters:params
                                    constructingBodyWithBlock:nil
                                    error:nil];
    
    
    [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      failure([error localizedDescription]);
    }];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"no_network_alert_msg", @"")];
    failure(NSLocalizedString(@"no_network_alert_msg", @""));
  }
}


- (void)performDeleteOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    
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
    failure(NSLocalizedString(@"no_network_alert_msg", @""));
  }
}


- (void)performPostOperationForProfileWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params andHeaderImageData:(NSData*)headerImageData andAvtarImageData:(NSData*)avtarImageData withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    NSString *url = [[NSURL URLWithString:urlString relativeToURL:manager.baseURL] absoluteString];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      if(headerImageData)
      {
        [formData appendPartWithFileData:headerImageData
                                    name:@"headphoto"
                                fileName:@"headphoto"
                                mimeType:@"image/jpeg"];
      }
      if(avtarImageData)
      {
        [formData appendPartWithFileData:avtarImageData
                                    name:@"avatarUrl"
                                fileName:@"avatarUrl"
                                mimeType:@"image/jpeg"];
      }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      failure([error localizedDescription]);
    }];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"no_network_alert_msg", @"")];
    failure(NSLocalizedString(@"no_network_alert_msg", @""));
  }
}

- (void)performImageUploadWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params image:(UIImage*)image andImageName:(NSString*)imageName withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure{
  
  if ([LCUtilityManager isNetworkAvailable])
  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30];
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      if (imageData) {
        [formData appendPartWithFileData:imageData
                                  name:imageName
                              fileName:@"image.png"
                              mimeType:@"image/png"];
      }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      failure([error localizedDescription]);
    }];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil
                                  andMessage:NSLocalizedString(@"No_network_alert_msg", @"")];
  }
}


@end
