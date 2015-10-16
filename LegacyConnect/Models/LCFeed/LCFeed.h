//
//  LCFeed.h
//  LegacyConnect
//
//  Created by Vishnu on 8/13/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCTag.h"

@interface LCFeed : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *feedId;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *likeCount;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *isMilestone;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *entityType;
@property (nonatomic, strong) NSString *entityID;
@property (nonatomic, strong) NSString *interestName;
@property (nonatomic, strong) NSString *interestID;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *didLike;
@property (nonatomic, strong) NSString *postType;
@property (nonatomic, strong) NSArray *postTags;

@end
