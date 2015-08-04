//
//  LCResponse.h
//  LegacyConnect
//
//  Created by Vishnu on 8/4/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSDictionary *data;
@end
