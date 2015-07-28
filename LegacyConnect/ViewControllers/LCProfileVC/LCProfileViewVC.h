//
//  LCProfileViewVC.h
//  LegacyConnect
//
//  Created by User on 7/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"


@interface LCProfileViewVC : UIViewController<UITableViewDataSource, UITableViewDelegate, feedCellDelegate>
{
  IBOutlet UITableView *H_milestonesTable;
  IBOutlet UIScrollView *H_interestsScrollview;
  NSMutableArray *H_cellsViewArray;
}

- (IBAction)backAction:(id)sender;
- (IBAction)toggleInterestOrMilestones:(UIButton *)sender;
- (IBAction)editClicked:(UIButton *)sender;

@end
