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
static NSString * const kReqstNotifications = @"requestNotifications";

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
  if ([[[LCDataManager sharedDataManager] notificationCount] integerValue] > 0) {
    [[LCDataManager sharedDataManager] setNotificationCount:@"0"];
    [LCNotificationManager postNotificationCountUpdatedNotification];
  }
  
  [LCTutorialManager showNotificationsTutorial];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:NO];
}

-(void) addTabMenuForNotifications
{
  [_requestsButton addTarget:self action:@selector(requestTabTapped) forControlEvents:UIControlEventTouchUpInside];
  
  self.tabMenu.menuButtons = @[_recentButton,_requestsButton];
  self.tabMenu.views = @[_recentContainer, _requestsContainer];
  self.tabMenu.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
}

- (void)requestTabTapped
{
  if(_tabMenu.currentIndex != 1)
  {
    if ([[[LCDataManager sharedDataManager] requestCount] integerValue] > 0)
    {
      [[LCDataManager sharedDataManager] setRequestCount:@"0"];
      [LCNotificationManager postNotificationCountUpdatedNotification];
    }
    [self updateRequestButtonTitle];
    [requestsView getRequests];
  }
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
  if([[LCUtilityManager performNullCheckAndSetValue:[LCDataManager sharedDataManager].requestCount] isEqualToString:kEmptyStringValue] || [[LCDataManager sharedDataManager].requestCount isEqualToString:@"0"])
  {
    [_requestsCountLabel setHidden:YES];
  }
  else
  {
    [_requestsCountLabel setHidden:NO];
    [_requestsCountLabel setText:[LCDataManager sharedDataManager].requestCount];
  }
}

@end
