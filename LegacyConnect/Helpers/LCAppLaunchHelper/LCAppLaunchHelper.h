//
//  LCAppLaunchHelper.h
//  LegacyConnect
//
//  Created by qbuser on 09/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAppLaunchHelper : NSObject

+ (NSString*)getPasswordResetTokenFromURLQuery:(NSString*)queryString;

@end
