//
//  LCSettings.h
//  LegacyConnect
//
//  Created by Jijo on 11/19/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSettings : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *privacy;
@property (nonatomic, strong) NSString *legacyUrl;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSArray *availablePrivacy;
@end
