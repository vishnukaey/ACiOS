//
//  LCSocialShareManager.h
//  LegacyConnect
//
//  Created by qbuser on 20/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSocialShareManager : NSObject

+ (BOOL)canShareToFacebook;
+ (BOOL)canShareToTwitter;

+ (void)shareToFacebookWithData:(NSDictionary*)data;
+ (void)shareToTwitterWithData:(NSDictionary*)data;


@end
