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
  IBOutlet UITableView *H_commentsTable;
  NSMutableArray *H_cellsViewArray;
}

- (IBAction)backAction:(id)sender;
- (IBAction)settingsAction:(id)sender;
- (IBAction)membersAction:(id)sender;
- (IBAction)websiteLinkAction:(id)sender;

@end
