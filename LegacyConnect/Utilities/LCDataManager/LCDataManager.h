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

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userToken;
@property (assign) BOOL isActive;
@end
