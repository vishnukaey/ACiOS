//
//  LCSettingsViewControllerTableViewController.h
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUpdateEmailViewController.h"
#import "LCChangePasswordViewController.h"
#import "LCPrivacyViewController.h"
#import "LCMyLegacyURLViewController.h"



@interface LCSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LCUpdateEmailDelegate, LCUpdateLegacyURLDelegate>
{
  __weak IBOutlet UITableView *settingsTableView;
}

@property (strong,nonatomic) LCSettings *settingsData;

@end
