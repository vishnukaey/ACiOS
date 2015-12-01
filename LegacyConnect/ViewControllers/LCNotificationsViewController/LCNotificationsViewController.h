//
//  LCNotificationsViewController.h
//  LegacyConnect
//
//  Created by Vishnu on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTabMenuView.h"

@interface LCNotificationsViewController : UIViewController
@property (weak, nonatomic) NSString *currentNotifications;
@property (weak, nonatomic) IBOutlet LCTabMenuView *tabMenu;
@property (weak, nonatomic) IBOutlet UIView *requestsContainer;
@property (weak, nonatomic) IBOutlet UIView *recentContainer;
@property (weak, nonatomic) IBOutlet UIButton *requestsButton;
@property (weak, nonatomic) IBOutlet UIButton *recentButton;
@property (weak, nonatomic) IBOutlet UILabel *requestsCountLabel;
@end
