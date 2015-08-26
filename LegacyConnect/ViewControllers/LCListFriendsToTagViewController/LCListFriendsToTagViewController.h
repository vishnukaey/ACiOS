//
//  LCListFriendsToTagViewController.h
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCMultipleSelectionTable.h"

@interface LCListFriendsToTagViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
  IBOutlet LCMultipleSelectionTable *friendsTableView;
  NSArray *friendsArray;
  NSMutableArray *searchResultsArray;
}

@property(nonatomic,retain) IBOutlet UIBarButtonItem *cancelButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *doneButton;
@property(nonatomic,retain) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@end
