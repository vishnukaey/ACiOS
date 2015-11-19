//
//  LCMenuItemCellTableViewCell.m
//  LegacyConnect
//
//  Created by qbuser on 29/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCMenuItemCell.h"

static NSString *kFeedIcon = @"FeedIcon";
static NSString *kInterestsIncon = @"InterestsIncon";
static NSString *kNotificationsIcon = @"NotificationsIcon";
static NSString *kSettingsIcon = @"SettingsIcon";

@implementation LCMenuItemCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIndex:(NSInteger)index
{
  [self.notificationCount setHidden:YES];
  [self.notificationLabelBG setHidden:YES];
  [self.notificationLabelBG.layer setCornerRadius:CGRectGetWidth(self.notificationLabelBG.frame) *0.5f];
  NSString * cellText;
  UIImage * cellIconImag;
  switch (index) {
    case 0:
      cellText = NSLocalizedString(@"Feed", nil) ;
      cellIconImag = [UIImage imageNamed:kFeedIcon];
      break;
      
    case 1:
      cellText = NSLocalizedString(@"Interests", nil) ;
      cellIconImag = [UIImage imageNamed:kInterestsIncon];
      break;
      
    case 2:
      cellText = NSLocalizedString(@"Notifications", nil) ;
      cellIconImag = [UIImage imageNamed:kNotificationsIcon];
      break;
      
    case 3:
      cellText = NSLocalizedString(@"Settings", nil) ;
      cellIconImag = [UIImage imageNamed:kSettingsIcon];
      [self updateNotificationCount];
      break;
      
    default:
      cellText = NSLocalizedString(@"Logout", nil) ;
      cellIconImag = nil;
      break;
  }
  [self.itemName setText:cellText];
  UIImage * iconImage = [cellIconImag imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.itemIcon setTintColor:[UIColor whiteColor]];
  [self.itemIcon setImage:iconImage];
}

- (void)updateNotificationCount
{
  NSInteger totalNotificationCount = [[[LCDataManager sharedDataManager] notificationCount] integerValue] + [[[LCDataManager sharedDataManager] requestCount] integerValue];
  [self.notificationCount setText:[NSString stringWithFormat:@"%li",(long)totalNotificationCount]];
  [self.notificationCount setHidden:NO];
  [self.notificationLabelBG setHidden:NO];
}

@end
