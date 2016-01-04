//
//  LCSingleCauseVC.h
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"

@interface LCSingleCauseVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
  IBOutlet UITableView *feedsTable;
  NSMutableArray *cellsViewArray;
  IBOutlet UILabel *causeNameLabel;
  IBOutlet UILabel *causeDescriptionLabel;
  IBOutlet UIButton *causeSupportersCountButton;
  IBOutlet UIButton *causeURLButton;
  IBOutlet UIImageView *causeImageView;
  IBOutlet UIButton *supportButton;
}

@property (strong, nonatomic) LCCause *cause;

- (IBAction)supportClicked:(id)sender;
- (IBAction)supportersListClicked:(id)sender;
- (IBAction)websiteLinkClicked:(id)sender;

@end
