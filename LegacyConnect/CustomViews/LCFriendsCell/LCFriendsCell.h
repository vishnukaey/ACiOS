//
//  LCFriendsCell.h
//  LegacyConnect
//
//  Created by qbuser on 21/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFriend.h"

typedef void (^AddFriendBtnAction)(LCFriend* friendObj);

@interface LCFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *friendsImageView;
@property (weak, nonatomic) IBOutlet UILabel * friendsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel * friendsLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton * addFriendBtn;
@property (weak, nonatomic) LCFriend * friendObj;

@property (nonatomic, strong) AddFriendBtnAction addFriendAction;

@end
