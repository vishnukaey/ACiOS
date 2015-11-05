//
//  LCViewActions.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCommentsController.h"
#import "LCTaggedLabel.h"


@interface LCViewActions : LCCommentsController
{
  IBOutlet NSLayoutConstraint *collapseViewHeight;
  IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  __weak IBOutlet UILabel *eventNameLabel;
  __weak IBOutlet LCTaggedLabel *eventCreatedByLabel;
  __weak IBOutlet UIImageView *eventPhoto;
  __weak IBOutlet UIButton *settingsButton;
}

@property(nonatomic, retain) LCEvent *eventObject;

- (IBAction)backAction:(id)sender;
- (IBAction)settingsAction:(id)sender;

@end
