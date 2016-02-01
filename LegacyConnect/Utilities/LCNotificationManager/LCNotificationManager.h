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
+ (void)postCommentedNotificationforPost:(LCFeed *)post andComment:(LCComment*)comment;
+ (void)postPostDeletedNotificationforPost: (LCFeed *)post;
+ (void)postPostEditedNotificationForPost :(LCFeed *)post;
+ (void)postRemoveMilestoneNotificationForPost :(LCFeed *)post;
+ (void)postPostReportedNotificationforPost: (LCFeed *)post;

// ------- Event ------//
+ (void)postEventFollowedNotificationWithEvent:(LCEvent*)event andResponse:(NSDictionary*)response;
+ (void)postEventUnFollowedNotificationWithEvent:(LCEvent*)event andResponse:(NSDictionary*)response;

+ (void)postEventCreatedNotificationWithResponse:(NSDictionary*)response;
+ (void)postEventDetailsUpdatedNotificationWithResponse:(NSDictionary*)response andEvent:(LCEvent*)event;
+ (void)postEventDeletedNotification:(LCEvent*)event;
+ (void)postEventRejectedNotification: (NSString *)eventID;
+ (void)postEventCommentedNotificationWithComment:(LCComment*)comment andEvent:(LCEvent*)event;

//profile updated
+ (void)postProfileUpdatedNotification :(LCUserDetail *)userDetails;

//friends
+ (void)postSendFriendRequestNotification :(NSString *)friendID forFriendStatus :(int)status;
+ (void)postCancelFriendRequestNotification :(NSString *)friendID forFriendStatus :(int)status;
+ (void)postRemoveFriendNotification :(NSString *)friendID forFriendStatus :(int)status;
+ (void)postAcceptFriendRequestNotification :(NSString *)friendID forFriendStatus :(int)status;
+ (void)postRejectFriendRequestNotification :(NSString *)friendID;
//Notification
+ (void)postNotificationCountUpdatedNotification;

//Interest
+ (void)postInterestFollowedNotificationWithInterest:(LCInterest*)interest;
+ (void)postInterestUnFollowedNotificationWithInterest:(LCInterest*)interest;

//cause
+ (void)postCauseFollowedNotificationWithCause:(LCCause *)cause;
+ (void)postCauseUnFollowedNotificationWithCause:(LCCause *)cause;

+ (void)postEventBlockedNotificationForEvent:(LCEvent*)event;

+ (void)postBlockedUserNotification :(NSString *)friendID forFriendStatus :(int)status;
@end
