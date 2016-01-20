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
#import "LCInterestPosts.h"
#import "LCInterestCauses.h"
#import "LCInterestActions.h"
#import "LCSingleInterestBC.h"

@interface LCSingleInterestVC : LCSingleInterestBC <LCInterestPostsDelegate, LCInterestCausesDelegate, LCInterestActionsDelegate>
{
  __weak IBOutlet LCTabMenuView *tabmenu;
  __weak IBOutlet NSLayoutConstraint *collapseViewHeight;
  
  __weak IBOutlet UIButton *postsButton;
  __weak IBOutlet UIButton *causesButton;
  __weak IBOutlet UIButton *actionsButton;
  
  __weak IBOutlet UIView *postsContainer;
  __weak IBOutlet UIView *causesContainer;
  __weak IBOutlet UIView *actionsContainer;
  
  
  LCInterestPosts *interestPostsView;
  LCInterestCauses *interestCausesView;
  LCInterestActions *interestActionsView;
  
}

@end
