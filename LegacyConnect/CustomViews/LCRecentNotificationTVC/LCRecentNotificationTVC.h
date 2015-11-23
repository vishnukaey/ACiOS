//
//  LCRecentNotificationTVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCRecentNotificationTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *notificDescription;
@property (weak, nonatomic) IBOutlet UILabel *details;

@property (nonatomic, strong) LCRecentNotification * notification;

+ (NSString*)getCellIdentifier;

@end
