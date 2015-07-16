//
//  LCUtilityManager.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "LCConstants.h"

@interface LCUtilityManager : NSObject

+ (BOOL)isNetworkAvailable;
+ (NSString *)performNullCheckAndSetValue:(NSString *)value;

@end
