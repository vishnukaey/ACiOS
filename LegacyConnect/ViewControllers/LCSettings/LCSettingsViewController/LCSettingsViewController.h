//
//  LCSettingsViewControllerTableViewController.h
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

+ (NSString*)getStoryBoardIdentifier;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end
