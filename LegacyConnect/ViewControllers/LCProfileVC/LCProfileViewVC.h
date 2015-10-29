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
#import <JTTableViewController.h>

typedef enum profileStateTypes
{
  PROFILE_SELF,
  PROFILE_OTHER_FRIEND,
  PROFILE_OTHER_NON_FRIEND,
  PROFILE_OTHER_WAITING
} profileState;

@interface LCProfileViewVC : JTTableViewController<UITableViewDataSource, UITableViewDelegate>
{
  IBOutlet UITableView *interestsTable;
  IBOutlet UITableView *actionsTable;
  
  IBOutlet UIImageView *profilePic, *headerImageView;
  IBOutlet UIView *profilePicBorderView;
  IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  IBOutlet UIButton *editButton, *backButton;
  IBOutlet UILabel *impactsCountLabel;
  IBOutlet UILabel *friendsCountLabel;
  IBOutlet UILabel *userNameLabel, *memeberSincelabel, *locationLabel;
  IBOutlet NSLayoutConstraint *collapseViewHeight;
  
  IBOutlet UIButton *mileStonesButton;
  IBOutlet UIButton *interestsButton;
  IBOutlet UIButton *actionsButton;
  
  NSArray *interestsArray;
  NSArray *actionsArray;
  
  LCTabMenuView *tabmenu;
  
  profileState currentProfileState;
}

@property(nonatomic, retain)LCUserDetail *userDetail;

- (IBAction)backAction:(id)sender;
- (IBAction)editClicked:(UIButton *)sender;
- (IBAction)friendsButtonClicked;
- (IBAction)impactsButtonClicked;

- (IBAction)mileStonesClicked:(id)sender;
- (IBAction)interestsClicked:(id)sender;
- (IBAction)actionsClicked:(id)sender;

@end
