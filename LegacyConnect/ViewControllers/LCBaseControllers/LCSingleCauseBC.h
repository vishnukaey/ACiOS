//
//  LCSingleCauseBC.h
//  LegacyConnect
//
//  Created by Jijo on 1/15/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "JTTableViewController.h"

@interface LCSingleCauseBC : JTTableViewController

@property (strong, nonatomic) LCCause *cause;

- (void)setNoResultViewHidden:(BOOL)hidded;

@end
