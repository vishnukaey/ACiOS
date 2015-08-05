//
//  LCAPIManager.h
//  LegacyConnect
//
//  Created by qbuser on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAPIManager : NSObject

+ (void)getInterestsWithSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;

@end
