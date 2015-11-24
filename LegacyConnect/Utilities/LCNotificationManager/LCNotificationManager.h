//
//  LCNotificationManager.h
//  LegacyConnect
//
//  Created by Jijo on 11/2/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCNotificationManager : NSObject
//--- posts --//
+ (void)postCreateNewPostNotificationfromResponse :(NSDictionary *)response;
+ (void)postLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post;
+ (void)postUnLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post;
+ (void)postCommentedNotificationforPost:(LCFeed *)post;
+ (void)postPostDeletedNotificationforPost: (LCFeed *)post;
+ (void)postPostEditedNotificationForPost :(LCFeed *)post;
+ (void)postRemoveMilestoneNotificationForPost :(LCFeed *)post;

// ------- Event ------//
+ (void)postEventCreatedNotificationWithEvent:(LCEvent*)event andResponse:(NSDictionary*)response;
+ (void)postEventMembersCountUpdatedNotification:(LCEvent*)event;
+ (void)postEventDetailsUpdatedNotificationWithResponse:(NSDictionary*)response andEvent:(LCEvent*)event;
+ (void)postEventDeletedNotification:(LCEvent*)event;

//friends
+ (void)postFriendUpadteNotification :(NSString *)friendID forFriendStatus :(int)status;

//Notification
+ (void)postNotificationCountUpdatedNotification;


@end
