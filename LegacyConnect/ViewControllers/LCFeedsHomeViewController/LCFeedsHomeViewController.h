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

@interface LCFeedsHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, feedCellDelegate>
{
  IBOutlet  UITableView *H_feedsTable;
  NSMutableArray *H_feedsViewArray;
}


@end
