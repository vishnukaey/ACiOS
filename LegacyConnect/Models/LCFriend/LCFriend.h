//
//  LCUser.h
//  LegacyConnect
//
//  Created by Vishnu on 7/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface LCFriend : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *friendId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *isFriend;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, assign) BOOL isInvitedToEvent;

@end
