//
//  LCConstantsNotification.h
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCConstantsNotification : NSObject

extern NSString *const kTwitterCallbackNotification;

extern NSString *const kUserDataUpdatedNotification;

extern NSString *const kUpdateProfileNFK;
extern NSString *const kCreateNewPostNFK;
extern NSString *const kUpdatePostNFK;
extern NSString *const kDeletePostNFK;
extern NSString *const kLikedPostNFK;
extern NSString *const kUnlikedPostNFK;
extern NSString *const kCommentPostNFK;
extern NSString *const kRemoveMileStoneNFK;
extern NSString *const kFollowInterestNFK;
extern NSString *const kUnfollowInterestNFK;
extern NSString *const kSupportCauseNFK;
extern NSString *const kUnsupportCauseNFK;
extern NSString *const kSendFriendRequestNFK;
extern NSString *const kCancelFriendRequestNFK;
extern NSString *const kRemoveFriendNFK;
extern NSString *const kAcceptFriendRequestNFK;
extern NSString *const kCreateEventNFK;
extern NSString *const kCommentEventNFK;
extern NSString *const kDeleteEventNFK;
extern NSString *const kUpdateEventNFK;
extern NSString *const kFollowEventNFK;
extern NSString *const kUnfollowEventNFK;

extern NSString *const kUserProfileUpdateNotification;
extern NSString *const kUserProfileFrinendsUpdateNotification;
extern NSString *const kUserProfilePostCreatedNotification;
extern NSString *const kUserProfilePostDeletedNotification;
extern NSString *const kfeedUpdatedotification;
extern NSString *const kNotificationCountUpdated;
extern NSString *const knewPostCreatedNotification;


extern NSString *const kResetPasswordNotificationName;

@end
