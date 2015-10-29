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
#import <JTTableViewController.h>

@interface LCFeedsHomeViewController : JTTableViewController<UITableViewDataSource, UITableViewDelegate>
{
  NSMutableArray *feedsArray;
}

@property (weak, nonatomic) IBOutlet  NSLayoutConstraint *customNavigationHeight;

@end
