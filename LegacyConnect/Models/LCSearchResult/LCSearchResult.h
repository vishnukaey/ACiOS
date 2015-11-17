//
//  LCSearchResult.h
//  LegacyConnect
//
//  Created by Vishnu on 9/2/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSearchResult : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *interestsArray;
@property (nonatomic, strong) NSMutableArray *causesArray;
@end
