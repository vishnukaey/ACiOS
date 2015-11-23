//
//  LCRecentNotification.h
//  LegacyConnect
//
//  Created by qbuser on 19/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCRecentNotification : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *actionId;
@property (nonatomic, strong) NSString *actionType;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *authorId;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) NSString *entityType;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *notificationId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL isRead;



@end
