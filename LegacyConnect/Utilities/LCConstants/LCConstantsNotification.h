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

extern NSString *const kUserProfileUpdateNotification;
extern NSString *const kUserProfileFrinendsUpdateNotification;
extern NSString *const kUserProfileImpactsUpdateNotification;
extern NSString *const kfeedUpdatedotification;
extern NSString *const friendStatusUpdatedNotification;
extern NSString *const kNotificationCountUpdated;
extern NSString *const knewPostCreatedNotification;

extern NSString *const kEventMemberCountUpdatedNotification;
extern NSString *const kEventDetailsUpdatedNotification;
extern NSString *const kEventDeletedNotification;
extern NSString *const kEventCreatedNotification;

extern NSString *const kResetPasswordNotificationName;

@end
