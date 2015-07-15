//
//  LCUtilityManager.h
//  LegacyConnect
//
//  Created by qbuser on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface LCUtilityManager : NSObject

+ (BOOL)isNetworkAvailable;

@end
