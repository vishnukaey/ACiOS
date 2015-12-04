//
//  LCUserDetail.h
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface LCUserDetail : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *headerPhotoURL;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *activationDate;
@property (nonatomic, strong) NSString *isFriend;
@property (nonatomic, strong) NSString *impactCount;
@property (nonatomic, strong) NSString *friendCount;
@property (nonatomic, strong) NSString *privacy;

- (void)performNullCheck;
@end
