//
//  LCRequest.h
//  LegacyConnect
//
//  Created by Kaey on 20/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCRequest : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *requestID;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *friendID;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *eventImage;
@property (nonatomic, strong) NSString *requestStatus;
@end
