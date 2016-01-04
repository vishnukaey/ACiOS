//
//  LCSingleInterestVC.h
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"
#import "LCTabMenuView.h"

@interface LCSingleInterestVC : UIViewController
{
//  IBOutlet UITableView *feedsTable;
//  IBOutlet UIScrollView *causesScrollView;
//  NSMutableArray *cellsViewArray;
  
  __weak IBOutlet UIView *tabMenuContainer;
  LCTabMenuView *tabmenu;
  
  __weak IBOutlet UIButton *postsButton;
  __weak IBOutlet UIButton *causesButton;
  __weak IBOutlet UIButton *actionsButton;
  
  __weak IBOutlet UIView *postsContainer;
  __weak IBOutlet UIView *causesContainer;
  __weak IBOutlet UIView *actionsContainer;
  
  
  __weak IBOutlet UILabel *interestName;
  __weak IBOutlet UILabel *interestDescription;
  __weak IBOutlet UIImageView *interestImage;
  __weak IBOutlet UIImageView *interestBGImage;
  __weak IBOutlet UIButton *interestFollowButton;
  
}

@property(nonatomic, strong) LCInterest *interest;

//- (IBAction)toggleHelpsORCauses:(UIButton *)sender;
//- (IBAction)backAction:(id)sender;
//- (IBAction)followButtonAction:(id)sender;

@end
