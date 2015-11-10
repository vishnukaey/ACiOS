//
//  LCImapactsViewController.h
//  LegacyConnect
//
//  Created by Jijo on 8/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedTableViewController.h"

@interface LCImapactsViewController : LCFeedTableViewController

@property (weak, nonatomic) IBOutlet  NSLayoutConstraint *customNavigationHeight;
@property(nonatomic, retain)LCUserDetail *userDetail;

@end
