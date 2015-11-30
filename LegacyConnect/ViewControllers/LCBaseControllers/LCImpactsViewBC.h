//
//  LCImpactsViewBC.h
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "JTTableViewController.h"

@interface LCImpactsViewBC : JTTableViewController

@property(nonatomic, retain)LCUserDetail *userDetail;

- (void)setNoResultViewHidden:(BOOL)hidded;

@end
