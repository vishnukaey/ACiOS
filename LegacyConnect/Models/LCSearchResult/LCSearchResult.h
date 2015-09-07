//
//  LCSearchResult.h
//  LegacyConnect
//
//  Created by Vishnu on 9/2/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSearchResult : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSArray *usersArray;
@property (nonatomic, strong) NSArray *interestsArray;
@property (nonatomic, strong) NSArray *causesArray;
@end
