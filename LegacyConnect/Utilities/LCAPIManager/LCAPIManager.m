//
//  LCAPIManager.m
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCAPIManager.h"
#import "LCWebServiceManager.h"

static LCAPIManager *sharedManager = nil;

@implementation LCAPIManager


+ (void)getInterestsWithSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure
{
  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, @"/api/interests"];
  [webService performGetOperationWithUrl:url withParameters:nil withSuccess:^(id response)
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
       success(responsesArray);
     }
   
   } andFailure:^(NSString *error) {
     NSLog(@"%@",error);
     [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
     failure(error);
   }];
}



@end