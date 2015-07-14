//
//  LCFeedsHomeViewController.h
//  LegacyConnect
//
//  Created by qbuser on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCFeedsHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
  IBOutlet  UITableView *H_feedsTable;
    
    NSMutableArray *H_feedsViewArray;
}


@end
