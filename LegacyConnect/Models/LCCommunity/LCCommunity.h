//
//  LCCommunity.h
//  LegacyConnect
//
//  Created by qbuser on 8/17/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCCommunity :  MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) UIImage *headerPhoto;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *communityDescription;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *interestID;

@end
