//
//  LCInterestPostsBC.h
//  LegacyConnect
//
//  Created by Jijo on 1/13/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTTableViewController.h"

@interface LCInterestPostsBC : JTTableViewController

  @property(nonatomic, retain) LCInterest *interest;
- (void)setNoResultViewHidden:(BOOL)hidded;
- (void)reloadPostsTable;
@end
