//
//  LCInviteToActions.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCMultipleSelectionTable.h"
#import "JTTableViewController.h"


@interface LCInviteToActions : JTTableViewController
{
  IBOutlet UISearchBar *searchBar;
  __weak IBOutlet UIButton *backButton;
  NSTimer *searchTimer;
  
  NSMutableArray *selectedIDs;
}

@property(nonatomic, retain)LCEvent *eventToInvite;

@end
