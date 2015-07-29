//
//  LCSingleInterestVC.h
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"

@interface LCSingleInterestVC : UIViewController<UITableViewDataSource, UITableViewDelegate, feedCellDelegate>
{
  IBOutlet UITableView *H_feedsTable;
  IBOutlet UIScrollView *H_causesScrollView;
  NSMutableArray *H_cellsViewArray;
}

- (IBAction)toggleHelpsORCauses:(UIButton *)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)followButtonAction:(id)sender;

@end
