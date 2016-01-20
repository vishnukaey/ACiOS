//
//  LCCause.h
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface LCCause : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *causeID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tagLine;
@property (nonatomic, strong) NSString *interestID;
@property (nonatomic, strong) NSString *logoURLLarge;
@property (nonatomic, strong) NSString *logoURLSmall;
@property (nonatomic, strong) NSString *supporters;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *themeColor;
@property (nonatomic, strong) NSString *themeBackgroundColor;
@property (nonatomic, strong) NSString *causeUrl;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, assign) BOOL isSupporting;
@end
