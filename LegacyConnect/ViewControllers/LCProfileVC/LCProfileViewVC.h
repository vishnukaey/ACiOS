//
//  LCProfileViewVC.h
//  LegacyConnect
//
//  Created by User on 7/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"

typedef enum profileStateTypes
{
  PROFILE_SELF,
  PROFILE_OTHER_FRIEND,
  PROFILE_OTHER_NON_FRIEND,
  PROFILE_OTHER_WAITING
} profileState;

@interface LCProfileViewVC : UIViewController<UITableViewDataSource, UITableViewDelegate, feedCellDelegate>
{
  IBOutlet UITableView *milestonesTable;
  IBOutlet UICollectionView *interestsCollectionView;
  IBOutlet UIImageView *profilePic, *headerImageView;
  IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  IBOutlet UIButton *impactsButton, *friendsButton, *editButton, *backButton;
  IBOutlet UILabel *userNameLabel, *memeberSincelabel, *locationLabel;
  IBOutlet NSLayoutConstraint *collapseViewHeight;
  NSArray *mileStoneFeeds;
  NSArray *interestsArray;
  
  profileState currentProfileState;
}

@property(nonatomic, retain)LCUserDetail *userDetail;

- (IBAction)backAction:(id)sender;
- (IBAction)editClicked:(UIButton *)sender;
- (IBAction)friendsButtonClicked;
- (IBAction)impactsButtonClicked;

@end
