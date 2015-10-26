//
//  LCSocialShareManager.h
//  LegacyConnect
//
//  Created by qbuser on 20/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

typedef void (^CanShareToTwitter) (BOOL canShare);

@interface LCSocialShareManager : NSObject <FBSDKSharingDelegate>

+ (void)canShareToTwitter:(void (^)(BOOL canShare))completionHandler;
+ (void)shareToTwitterWithStatus:(NSString*)status andImage:(UIImage*)image;


+ (void)canShareToFacebook:(void (^)(BOOL canShare))completionHandler;
- (void)shareToFacebookWithMessage:(NSString *)message andImage:(UIImage *)image;


@end
