//
//  LCNotificationsViewController.h
//  LegacyConnect
//
//  Created by qbuser on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCNotificationsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *currentNotifications;
@end
