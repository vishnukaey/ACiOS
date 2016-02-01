//
//  LCBlockedUsersCell.h
//  LegacyConnect
//
//  Created by qbuser on 30/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBlockedUsersCell : UITableViewCell

@property (nonatomic, strong) LCUserDetail * userDetails;
@property (weak, nonatomic) IBOutlet UIImageView *friendsImageView;
@property (weak, nonatomic) IBOutlet UILabel * friendsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel * friendsLocationLabel;

@end
