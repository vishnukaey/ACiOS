//
//  LCTheme.h
//  LegacyConnect
//
//  Created by qbuser on 14/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface LCTheme : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *themeID;
@property (nonatomic, strong) NSArray *interests;

@end
