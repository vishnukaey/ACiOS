//
//  LCNotificationsAPIManager.h
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCNotificationsAPIManager : NSObject

+ (void)getNotificationCountWithStatus:(void (^)(BOOL status))status;
+ (void)getRecentNotificationsWithLastId:(NSString*)lastId withSuccess:(void(^)(id response))success andFailure:(void(^)(NSString*error))failure;
+ (void)getRequestNotificationsWithLastUserId:(NSString*)lastId withSuccess:(void (^)(NSArray* responses))success andfailure:(void (^)(NSString *error))failure;
+ (void)markNotificationAsRead:(NSString*)notificationId andStatus:(void (^)(BOOL status))status;
+ (void)rejectEventRequest:(NSString *)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

@end
