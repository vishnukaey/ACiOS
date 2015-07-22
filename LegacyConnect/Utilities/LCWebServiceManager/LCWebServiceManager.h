//
//  LCWebServiceManager.h
//  LegacyConnect
//
//  Created by qbuser on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface LCWebServiceManager : NSObject

- (void)performPostOperationWithUrl:(NSString *)urlString withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

- (void)performGetOperationWithUrl:(NSString *)urlString withParameters:(NSDictionary *)params withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;


@end
