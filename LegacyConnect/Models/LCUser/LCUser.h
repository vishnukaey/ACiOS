//
//  LCUser.h
//  LegacyConnect
//
//  Created by Vishnu on 7/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUser : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSData *userImage;

@end
