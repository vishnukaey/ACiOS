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
  IBOutlet UITableView *milestonesTable;
  IBOutlet UIScrollView *interestsScrollview;
  IBOutlet UIImageView *profilePic;
  IBOutlet UIView *tabMenuContainer;
  NSMutableArray *MileStones;
}

- (IBAction)backAction:(id)sender;
- (IBAction)toggleInterestOrMilestones:(UIButton *)sender;
- (IBAction)editClicked:(UIButton *)sender;

@end
