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
  [manager.requestSerializer setValue:[LCUtilityManager getAppVersion] forHTTPHeaderField:kLCVersionKey];
  [manager POST:urlString parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
     NSString *statusCode = [NSString stringWithFormat:@"%@",responseObject[kStatusCodeKey]];
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     if([statusCode isEqualToString:kStatusCodeSuccess])
     {
       success(responseObject);
     }
     else if([statusCode isEqualToString:kStatusCodeVersionFailure])//version expired
     {
       [LCUtilityManager showVersionOutdatedAlert];
     }
     else//101
     {
       failure(responseObject[kResponseMessage]);
     }
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
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
  }
  else
  {
    [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
  }
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  [manager.requestSerializer setTimeoutInterval:30];
  [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
  [manager.requestSerializer setValue:[LCUtilityManager getAppVersion] forHTTPHeaderField:kLCVersionKey];
  [manager GET:urlString parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
     NSString *statusCode = [NSString stringWithFormat:@"%@",responseObject[kStatusCodeKey]];
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     if([statusCode isEqualToString:kStatusCodeSuccess])
     {
       success(responseObject);
     }
     else if([statusCode isEqualToString:kStatusCodeVersionFailure])//version expired
     {
       [LCUtilityManager showVersionOutdatedAlert];
     }
     else//101
     {
       failure(responseObject[kResponseMessage]);
     }
   }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
   {
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     NSString *errorMsg = operation.responseObject[kResponseMessage];
     (!errorMsg||[errorMsg isKindOfClass:[NSNull class]] ? failure([error localizedDescription]) : failure(errorMsg));
     LCDLog(@"error is %@", [error localizedDescription]);
   }];
}


- (void)performPutOperationWithUrl:(NSString *)urlString andAccessToken:(NSString*)accessToken withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager.requestSerializer setTimeoutInterval:30];
  [manager.requestSerializer setValue:accessToken forHTTPHeaderField:kAuthorizationKey];
  [manager.requestSerializer setValue:[LCUtilityManager getAppVersion] forHTTPHeaderField:kLCVersionKey];
  NSString *url = [[NSURL URLWithString:urlString relativeToURL:manager.baseURL] absoluteString];
  NSMutableURLRequest *request = [manager.requestSerializer
                                  multipartFormRequestWithMethod:@"PUT"
                                  URLString:url
                                  parameters:params
                                  constructingBodyWithBlock:nil
                                  error:nil];
  
  
  [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *statusCode = [NSString stringWithFormat:@"%@",responseObject[kStatusCodeKey]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([statusCode isEqualToString:kStatusCodeSuccess])
    {
      success(responseObject);
    }
    else if([statusCode isEqualToString:kStatusCodeVersionFailure])//version expired
    {
      [LCUtilityManager showVersionOutdatedAlert];
    }
    else//101
    {
      failure(responseObject[kResponseMessage]);
    }
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
  [manager.requestSerializer setValue:[LCUtilityManager getAppVersion] forHTTPHeaderField:kLCVersionKey];
  manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
  [manager DELETE:urlString
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
     NSString *statusCode = [NSString stringWithFormat:@"%@",responseObject[kStatusCodeKey]];
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     if([statusCode isEqualToString:kStatusCodeSuccess])
     {
       success(responseObject);
     }
     else if([statusCode isEqualToString:kStatusCodeVersionFailure])//version expired
     {
       [LCUtilityManager showVersionOutdatedAlert];
     }
     else//101
     {
       failure(responseObject[kResponseMessage]);
     }
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
  [manager.requestSerializer setValue:[LCUtilityManager getAppVersion] forHTTPHeaderField:kLCVersionKey];
  NSString *url = [[NSURL URLWithString:urlString relativeToURL:manager.baseURL] absoluteString];
  
  // MultiPart upload if there are images
  if(imagesArray && imagesArray.count > 0)
  {
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      for(LCImage *image in imagesArray)
      {
        if(image)
        {
          [formData appendPartWithFileData:[LCUtilityManager performNormalisedImageCompression:image.image]
                                      name:image.imageKey
                                  fileName:image.imageKey
                                  mimeType:@"image/jpeg"];
        }
      }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSString *statusCode = [NSString stringWithFormat:@"%@",responseObject[kStatusCodeKey]];
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      if([statusCode isEqualToString:kStatusCodeSuccess])
      {
        success(responseObject);
      }
      else if([statusCode isEqualToString:kStatusCodeVersionFailure])//version expired
      {
        [LCUtilityManager showVersionOutdatedAlert];
      }
      else//101
      {
        failure(responseObject[kResponseMessage]);
      }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      failure([error localizedDescription]);
    }];
  }
  else
  {
    [LCWebServiceManager ordinaryPostOperationWithManager:manager Url:urlString parameters:params withSuccess:success andFailure:failure];
  }
}

+ (void)ordinaryPostOperationWithManager:(AFHTTPRequestOperationManager*)manager Url:(NSString *)urlString parameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure
{
  // Oridinary Post in case of no images
  
  [manager POST:urlString parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
     NSString *statusCode = [NSString stringWithFormat:@"%@",responseObject[kStatusCodeKey]];
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     if([statusCode isEqualToString:kStatusCodeSuccess])
     {
       success(responseObject);
     }
     else if([statusCode isEqualToString:kStatusCodeVersionFailure])//version expired
     {
       [LCUtilityManager showVersionOutdatedAlert];
     }
     else//101
     {
       failure(responseObject[kResponseMessage]);
     }
   }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
   {
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     failure([error localizedDescription]);
   }];

}

@end
