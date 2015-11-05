//
//  LCViewActions.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCViewActions : UIViewController
{
  IBOutlet UITableView *mainTableView;
  IBOutlet NSLayoutConstraint *collapseViewHeight;
  IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  LCEvent * eventObject;
  NSMutableArray *commentsArray;
}

@property(nonatomic, retain)NSString *eventID;

- (IBAction)backAction:(id)sender;
- (IBAction)settingsAction:(id)sender;
- (IBAction)membersAction:(id)sender;
- (IBAction)websiteLinkAction:(id)sender;

@end
