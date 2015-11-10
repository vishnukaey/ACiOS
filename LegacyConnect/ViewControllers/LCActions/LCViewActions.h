//
//  LCViewActions.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCEventDetailsBaseController.h"
#import "LCTaggedLabel.h"


@interface LCViewActions : LCEventDetailsBaseController
{
  IBOutlet NSLayoutConstraint *collapseViewHeight;
  IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  __weak IBOutlet UILabel *eventNameLabel;
  __weak IBOutlet LCTaggedLabel *eventCreatedByLabel;
  __weak IBOutlet UIImageView *eventPhoto;
}

- (IBAction)backAction:(id)sender;
- (IBAction)settingsAction:(id)sender;

@end
