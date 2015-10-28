//
//  LCWebServiceManager.m
//  LegacyConnect
//
//  Created by Vishnu on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCWebServiceManager.h"
#import "LCImage.h"

@implementation LCWebServiceManager


- (void)performPostOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  [manager.requestSerializer setTimeoutInterval:30];
  [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
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



- (void)performGetOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  if([LCUtilityManager isNetworkAvailable])
  {
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
  }
  else
  {
    [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
  }
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  [manager.requestSerializer setTimeoutInterval:30];
  [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
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


- (void)performPutOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager.requestSerializer setTimeoutInterval:30];
  [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
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


- (void)performDeleteOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
  manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
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

- (void)performPostOperationWithUrl:(NSString *)urlString accessToken:(NSString*)accessToken parameters:(NSDictionary *)params andImagesArray:(NSMutableArray*)imagesArray withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager.requestSerializer setTimeoutInterval:30];
  [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
  NSString *url = [[NSURL URLWithString:urlString relativeToURL:manager.baseURL] absoluteString];
  
  // MultiPart upload if there are images
  if(imagesArray && imagesArray.count > 0)
  {
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      for(LCImage *image in imagesArray)
      {
        if(image)
        {
          [formData appendPartWithFileData:UIImagePNGRepresentation(image.image)
                                      name:image.imageKey
                                  fileName:image.imageKey
                                  mimeType:@"image/jpeg"];
        }
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
    // Oridinary Post in case of no images
    
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
}

@end
