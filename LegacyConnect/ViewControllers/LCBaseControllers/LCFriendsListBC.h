//
//  LCFriendsListBC.h
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCUsersListBC.h"

@interface LCFriendsListBC : LCUsersListBC

@property (nonatomic, strong) NSString * userId;

- (void)setNoResultViewHidden:(BOOL)hidded;

@end
