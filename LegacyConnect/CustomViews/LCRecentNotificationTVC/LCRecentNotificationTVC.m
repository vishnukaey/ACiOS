//
//  LCRecentNotificationTVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCRecentNotificationTVC.h"

static NSString *kNotificationCellIdentifier = @"LCRecentNotificationTVC";
#define kUnReadNotificationCellBG [UIColor colorWithRed:254/255.0 green:249/255.0 blue:235/255.0 alpha:1]
#define kReadNotificationCellBG [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]

@implementation LCRecentNotificationTVC

+ (NSString*)getCellIdentifier
{
  return kNotificationCellIdentifier;
}

- (void)setNotification:(LCRecentNotification *)notification
{
  _notification = notification;
  [self.authorImageView.layer setCornerRadius:CGRectGetWidth(self.authorImageView.frame) * 0.5f];
  [self.authorImageView sd_setImageWithURL:[NSURL URLWithString:notification.avatarUrl] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  NSString * authorName = [NSString stringWithFormat:@"%@ %@",[LCUtilityManager performNullCheckAndSetValue:notification.firstName],[LCUtilityManager performNullCheckAndSetValue:notification.lastName]];
  [self.name setText:authorName];
  [self.notificDescription setText:[LCUtilityManager performNullCheckAndSetValue:notification.caption]];
  if (![LCUtilityManager isEmptyString:notification.message]) {
    NSString * detailsText = [NSString stringWithFormat:@"\"%@\"",notification.message];
    [self.details setText:detailsText];
  }
  [self setBackgroundColor:(notification.isRead ? kReadNotificationCellBG : kUnReadNotificationCellBG)];
}

@end
