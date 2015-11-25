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

#import "LCMileStonesVC.h"
#import "LCInterestsVC.h"
#import "LCActionsVC.h"

@interface LCProfileViewVC : LCProfileViewBC <MileStonesDelegate, InterestsDelegate, ActionsDelegate>
{
  
  IBOutlet UIImageView *profilePic, *headerImageView;
  IBOutlet UIView *profilePicBorderView;
  IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  IBOutlet UIButton *backButton;
  IBOutlet UILabel *userNameLabel, *memeberSincelabel, *locationLabel;
  IBOutlet NSLayoutConstraint *collapseViewHeight;
  
  
  IBOutlet UIButton *mileStonesButton;
  IBOutlet UIButton *interestsButton;
  IBOutlet UIButton *actionsButton;
  
  IBOutlet UIView *milestonesContainer;
  IBOutlet UIView *interestsContainer;
  IBOutlet UIView *actionsContainer;
  
  LCMileStonesVC *mileStonesVC;
  LCInterestsVC *interestsVC;
  LCActionsVC *actionsVC;
  
  
  NSArray *interestsArray;
  NSArray *actionsArray;
  
  
  LCTabMenuView *tabmenu;
}

//@property(nonatomic, retain)LCUserDetail *userDetail;

- (IBAction)backAction:(id)sender;
- (IBAction)editClicked:(UIButton *)sender;
- (IBAction)friendsButtonClicked;
- (IBAction)impactsButtonClicked;

- (IBAction)mileStonesClicked:(id)sender;
- (IBAction)interestsClicked:(id)sender;
- (IBAction)actionsClicked:(id)sender;

@property (nonatomic) NSInteger navCount;

@end
