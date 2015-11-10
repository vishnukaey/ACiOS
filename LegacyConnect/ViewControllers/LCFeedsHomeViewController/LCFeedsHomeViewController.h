//
//  LCFeedsHomeViewController.h
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"
#import "LCFeedsCommentsController.h"
#import "LCFeedTableViewController.h"

@interface LCFeedsHomeViewController : LCFeedTableViewController<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet  NSLayoutConstraint *customNavigationHeight;

@end
