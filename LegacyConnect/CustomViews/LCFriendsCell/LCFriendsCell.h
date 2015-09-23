//
//  LCFriendsCell.h
//  LegacyConnect
//
//  Created by qbuser on 21/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFriend.h"

@interface LCFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *friendsImageView;
@property (weak, nonatomic) IBOutlet UILabel * friendsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel * friendsLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton * addRemoveFriendBtn;
@property (weak, nonatomic) LCFriend * friendObj;

@end
