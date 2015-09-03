//
//  LCTag.h
//  LegacyConnect
//
//  Created by Vishnu on 8/13/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCTag : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *tagID;
@property (nonatomic, strong) NSString *text;
@end
