//
//  LCmileStonesBC.h
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "JTTableViewController.h"

@interface LCMileStonesBC : JTTableViewController

@property (nonatomic, assign) BOOL isSelfProfile;
@property (nonatomic, assign)CGFloat tableContentHeight;//for persisting the height after adding offset for GIButton

- (void)setNoResultViewHidden:(BOOL)hidded;
- (void)reloadMilestonesTable;

@end
