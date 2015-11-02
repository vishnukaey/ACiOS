//
//  LCNotificationManager.h
//  LegacyConnect
//
//  Created by Jijo on 11/2/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCNotificationManager : NSObject

+ (void)postLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post;
+ (void)postUnLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post;
+ (void)postCommentedNotificationforPost:(LCFeed *)post;
@end
