//
//  LCNotificationsViewController.m
//  LegacyConnect
//
//  Created by qbuser on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCNotificationsViewController.h"
#import "LCRecentNotificationTVC.h"
#import "LCRequestNotificationTVC.h"
#import "LCFeedsCommentsController.h"

static NSString * const kRecentNotifications = @"recentNotifications";
static NSString * const kRequestNotifications = @"requestNotifications";

@interface LCNotificationsViewController ()

@end

@implementation LCNotificationsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  _currentNotifications = kRecentNotifications;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if([_currentNotifications isEqualToString:kRecentNotifications])
  {
    return 5;
  }
  else
  {
    return 10;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([_currentNotifications isEqualToString:kRecentNotifications])
  {
    static NSString *MyIdentifier = @"LCRecentNotificationTVC";
    LCRecentNotificationTVC *cell = (LCRecentNotificationTVC*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      cell = [[LCRecentNotificationTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    return cell;
  }
  
  else
  {
    static NSString *MyIdentifier = @"LCRequestNotificationTVC";
    LCRequestNotificationTVC *cell = (LCRequestNotificationTVC*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      cell = [[LCRequestNotificationTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    return cell;
  }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([_currentNotifications isEqualToString:kRecentNotifications])
  {
    return 120.0;
  }
  else
  {
    return 110.0;
  }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([_currentNotifications isEqualToString:kRecentNotifications])
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
    
    [self.navigationController pushViewController:next animated:YES];
  }
  else
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile"
                                                  bundle:nil];
    LCFeedsCommentsController *next = [sb instantiateInitialViewController];
    
    [self.navigationController pushViewController:next animated:YES];
  }
}

- (IBAction)toggleNotificationTab:(id)sender
{
  UIButton *senderButton = (UIButton*)sender;
  if(senderButton.tag == 1)
  {
    _currentNotifications = kRecentNotifications;
    [_tableView reloadData];
  }
  else
  {
    _currentNotifications = kRequestNotifications;
    [_tableView reloadData];
  }
}

@end
