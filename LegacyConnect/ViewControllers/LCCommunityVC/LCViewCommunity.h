//
//  LCViewCommunity.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCViewCommunity : UIViewController
{
  IBOutlet UITableView *mainTableView;
  IBOutlet NSLayoutConstraint *collapseViewHeight;
  IBOutlet UIView *tabMenuContainer, *viewToCollapse;
  NSString *communityDetails;
  NSString *communityMembersCount;
  NSString *communityWebsite;
  NSMutableArray *commentsArray;
}

- (IBAction)backAction:(id)sender;
- (IBAction)settingsAction:(id)sender;
- (IBAction)membersAction:(id)sender;
- (IBAction)websiteLinkAction:(id)sender;

@end
