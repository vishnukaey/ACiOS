//
//  LCReportHelper.m
//  LegacyConnect
//
//  Created by Akhil K C on 1/30/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCReportHelper.h"
#import "LCBlockUserViewController.h"
#import "LCReportPostViewController.h"
#import "LCBlockActionViewController.h"

@implementation LCReportHelper

+ (void)showPostReportActionSheetFromView:(UIViewController*)presentingView withPost:(LCFeed*)feed
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *blockUser = [UIAlertAction actionWithTitle:NSLocalizedString(@"block_user", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    UIStoryboard*  mainSB = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier
                                                      bundle:nil];
    LCBlockUserViewController *blockUserVC = [mainSB instantiateViewControllerWithIdentifier:@"LCBlockUserViewController"];
    LCUserDetail *userDetail = [[LCUserDetail alloc] init];
    userDetail.userID = feed.userID;
    userDetail.firstName = feed.firstName;
    userDetail.lastName = feed.lastName;
    [presentingView presentViewController:blockUserVC animated:YES completion:nil];
  }];
  [actionSheet addAction:blockUser];
  
  UIAlertAction *reportPost = [UIAlertAction actionWithTitle:NSLocalizedString(@"report_post", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    UIStoryboard*  mainSB = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier
                                                      bundle:nil];
    LCReportPostViewController *report = [mainSB instantiateViewControllerWithIdentifier:@"LCReportPostViewController"];
    report.postToReport = feed;
    [presentingView presentViewController:report animated:YES completion:nil];
  }];
  [actionSheet addAction:reportPost];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [presentingView presentViewController:actionSheet animated:YES completion:nil];
}

+ (void)showActionReportActionSheetFromView:(UIViewController*)presentingView withAction:(LCEvent*)event
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *blockAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"block_action", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    UIStoryboard*  mainSB = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier
                                                      bundle:nil];
    LCBlockActionViewController *blockActionVC = [mainSB instantiateViewControllerWithIdentifier:@"LCBlockActionViewController"];
    blockActionVC.eventToBlock = event;
    [presentingView presentViewController:blockActionVC animated:YES completion:nil];
  }];
  [actionSheet addAction:blockAction];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [presentingView presentViewController:actionSheet animated:YES completion:nil];
}

@end
