//
//  LCRecentNotificationTVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCRecentNotificationTVC.h"

static NSString *kNotificationCellIdentifier = @"LCRecentNotificationTVC";

@implementation LCRecentNotificationTVC

+ (NSString*)getCellIdentifier
{
  return kNotificationCellIdentifier;
}

- (void)setNotification:(LCRecentNotification *)notification
{
  _notification = notification;
  [self.authorImageView sd_setImageWithURL:[NSURL URLWithString:notification.avatarUrl] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  NSString * authorName = [NSString stringWithFormat:@"%@ %@",[LCUtilityManager performNullCheckAndSetValue:notification.firstName],[LCUtilityManager performNullCheckAndSetValue:notification.lastName]];
  [self.name setText:authorName];
  [self.notificDescription setText:[LCUtilityManager performNullCheckAndSetValue:notification.caption]];
  [self.details setText:[LCUtilityManager performNullCheckAndSetValue:nil]];
}

@end
