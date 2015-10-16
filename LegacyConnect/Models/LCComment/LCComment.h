//
//  LCComment.h
//  LegacyConnect
//
//  Created by qbuser on 15/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCComment : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *commentText;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@end
