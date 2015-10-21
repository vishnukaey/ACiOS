//
//  LCUserTableViewCell.h
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCfriendButton.h"

@interface LCUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet LCfriendButton *userAddButton;
@property (weak, nonatomic) LCUserDetail *user;
@end
