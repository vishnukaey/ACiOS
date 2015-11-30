//
//  LCNotificationsViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCNotificationsViewController.h"
#import "LCRecentNotificationTVC.h"
#import "LCRequestNotificationTVC.h"
#import "LCFeedsCommentsController.h"
#import "LCRecentNotificationsVC.h"
#import "LCRequestsNotificationsVC.h"

static NSString * const kRecentNotifications = @"recentNotifications";
static NSString * const kRequestNotifications = @"requestNotifications";

@interface LCNotificationsViewController ()
{
  LCRecentNotificationsVC *recentView;
  LCRequestsNotificationsVC *requestsView;
}

@end

@implementation LCNotificationsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  _currentNotifications = kRecentNotifications;
  [self addTabMenuForNotifications];
  [self updateRequestButtonTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:YES];
  [appdel.menuButton setHidden:NO];
}

-(void) addTabMenuForNotifications
{
  self.tabMenu.menuButtons = @[_recentButton,_requestsButton];
  self.tabMenu.views = @[_recentContainer, _requestsContainer];
  self.tabMenu.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
  self.tabMenu.highlightColor = [UIColor colorWithRed:240.0/255.0 green:100/255.0 blue:77/255.0 alpha:1.0];
  self.tabMenu.normalColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
}


- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"LCRecentNotificationsVC"]) {
    
    recentView = segue.destinationViewController;
  }
  else if ([segue.identifier isEqualToString:@"LCRequestsNotificationsVC"]) {
    
    requestsView = segue.destinationViewController;
  }
}


-(void) updateRequestButtonTitle
{
  if([LCUtilityManager performNullCheckAndSetValue:[LCDataManager sharedDataManager].requestCount] || [[LCDataManager sharedDataManager].requestCount isEqualToString:@"0"])
  {
    [_requestsButton setTitle:@"REQUESTS" forState:UIControlStateNormal];
  }
  else
  {
    [_requestsButton setTitle:[NSString stringWithFormat:@"REQUESTS %@",[LCDataManager sharedDataManager].requestCount] forState:UIControlStateNormal];
  }
}

@end
