//
//  LCDataManager.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCDataManager : NSObject

+ (LCDataManager *)sharedDataManager;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *dob;
@property (strong, nonatomic) NSString *avatarUrl;
@property (nonatomic, strong) NSString *headerPhotoURL;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userFBID;
@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *createdDateTime;
@property (strong, nonatomic) NSData *userImageData;
@property (assign) BOOL isActive;
@end
