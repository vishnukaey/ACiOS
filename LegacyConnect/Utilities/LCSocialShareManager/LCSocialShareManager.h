//
//  LCSocialShareManager.h
//  LegacyConnect
//
//  Created by qbuser on 20/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CanShareToTwitter) (BOOL canShare);

@interface LCSocialShareManager : NSObject

+ (BOOL)canShareToFacebook;
+ (void)canShareToTwitter:(CanShareToTwitter)canShare;

+ (void)shareToFacebookWithData:(NSDictionary*)data;
+ (void)shareToTwitterWithStatus:(NSString*)status andImage:(UIImage*)image;


@end
