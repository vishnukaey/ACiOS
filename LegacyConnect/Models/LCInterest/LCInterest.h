//
//  LCInterest.h
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCInterest : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *interestID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) NSArray *causes;
@end
