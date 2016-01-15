//
//  LCSingleCauseVC.h
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"
#import "LCSingleCauseBC.h"


@interface LCSingleCauseVC : LCSingleCauseBC
{
  __weak IBOutlet NSLayoutConstraint *collapseViewHeight;
  NSMutableArray *cellsViewArray;
}


- (IBAction)supportClicked:(id)sender;
- (IBAction)supportersListClicked:(id)sender;
- (IBAction)websiteLinkClicked:(id)sender;

@end
