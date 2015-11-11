//
//  LCEvent.h
//  LegacyConnect
//
//  Created by Vishnu on 8/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCEvent : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *headerPhoto;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *followerCount;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *interestID;
@property (nonatomic, strong) NSString *ownerFirstName;
@property (nonatomic, strong) NSString *ownerLastName;
@property (nonatomic, strong) NSString *interestName;
@property (nonatomic, strong) NSString *userID;
@property (assign) BOOL isOwner;
@property (assign) BOOL isFollowing;
@property (nonatomic, strong) NSArray *comments;
@end
