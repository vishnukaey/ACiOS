//
//  LCProfileViewVC.h
//  LegacyConnect
//
//  Created by User on 7/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"
#import "LCInterestsCellView.h"
#import "LCActionsCellView.h"
#import "LCTabMenuView.h"
#import "LCProfileViewBC.h"

@interface LCProfileViewVC : LCProfileViewBC <MileStonesDelegate, InterestsDelegate, ActionsDelegate>
{
  
  __weak IBOutlet UIView *profilePicBorderView;
  __weak IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  __weak IBOutlet UIButton *backButton;
  __weak IBOutlet NSLayoutConstraint *collapseViewHeight;
  
  __weak IBOutlet UIButton *mileStonesButton;
  __weak IBOutlet UIButton *interestsButton;
  __weak IBOutlet UIButton *actionsButton;
  
  __weak IBOutlet UIView *milestonesContainer;
  __weak IBOutlet UIView *interestsContainer;
  __weak IBOutlet UIView *actionsContainer;
  
  NSArray *interestsArray;
  NSArray *actionsArray;
  
  IBOutlet LCTabMenuView *tabmenu;
}

- (IBAction)backAction:(id)sender;
- (IBAction)editClicked:(UIButton *)sender;
- (IBAction)friendsButtonClicked;
- (IBAction)impactsButtonClicked;

- (IBAction)mileStonesClicked:(id)sender;
- (IBAction)interestsClicked:(id)sender;
- (IBAction)actionsClicked:(id)sender;

@end
