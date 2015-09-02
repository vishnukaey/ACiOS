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
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *interestID;

@end
