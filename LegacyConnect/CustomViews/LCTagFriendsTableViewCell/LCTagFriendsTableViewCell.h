//
//  LCTagFriendsTableViewCell.h
//  LegacyConnect
//
//  Created by Govind_Office on 12/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTagFriendsTableViewCell : UITableViewCell


@property(nonatomic,retain) IBOutlet UIImageView *friendImageView;
@property(nonatomic,retain) IBOutlet UILabel *friendNameLabel;
@property(nonatomic,retain) IBOutlet UIButton *friendSelectionButton;

@end
