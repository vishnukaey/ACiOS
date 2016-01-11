//
//  LCListFriendsToTagViewController.h
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTTableViewController.h"

@protocol LCListFriendsToTagViewControllerDelegate <NSObject>

- (void)didFinishPickingFriends :(NSArray *)friendsArray;

@end

@interface LCListFriendsToTagViewController : JTTableViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
  NSTimer *searchTimer;
}

@property(nonatomic, retain) id delegate;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *cancelButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *doneButton;
@property(nonatomic,retain) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic, retain) NSArray *alreadySelectedFriends;
@property (nonatomic,retain) NSString *searchKey;
@property (nonatomic,retain) NSMutableArray *selectedIDs;
@end
