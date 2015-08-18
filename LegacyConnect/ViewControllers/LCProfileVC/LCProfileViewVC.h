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
  IBOutlet UICollectionView *interestsCollectionView;
  IBOutlet UIImageView *profilePic, *headerImageView;
  IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  IBOutlet UIButton *impactsButton, *friendsButton, *editButton;
  IBOutlet UILabel *userNameLabel, *memeberSincelabel, *locationLabel;
  NSArray *mileStoneFeeds;
  NSArray *interestsArray;
}

@property(nonatomic, weak)IBOutlet NSLayoutConstraint *collapseViewHeight;
@property(nonatomic, retain)NSString *userID;

- (IBAction)backAction:(id)sender;
- (IBAction)editClicked:(UIButton *)sender;
- (IBAction)friendsButtonClicked;
- (IBAction)impactsButtonClicked;

@end
