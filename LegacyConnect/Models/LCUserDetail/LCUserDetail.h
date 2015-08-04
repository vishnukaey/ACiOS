//
//  LCUserDetail.h
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUserDetail : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *avtarURL;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *headerPhotoURL;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *activationDate;
@end
