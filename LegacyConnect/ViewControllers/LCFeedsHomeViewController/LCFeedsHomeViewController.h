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
#import "MFSideMenu.h"
#import "LCLeftMenuController.h"

@interface LCFeedsHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, feedCellDelegate, leftMenuDelegate>
{
  IBOutlet  UITableView *H_feedsTable;
    
    NSMutableArray *H_feedsViewArray;
}

@property(nonatomic, retain)MFSideMenuContainerViewController *P_containerController;


@end
