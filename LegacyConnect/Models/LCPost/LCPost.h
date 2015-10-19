//
//  LCNewPost.h
//  LegacyConnect
//
//  Created by Akhil K C on 10/13/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPost : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *isMilestone;
@property (nonatomic, strong) NSString *postToType;
@property (nonatomic, strong) NSString *postToID;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSArray *postTags;

@end
