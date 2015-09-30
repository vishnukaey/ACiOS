//
//  LCMenuItemCellTableViewCell.h
//  LegacyConnect
//
//  Created by qbuser on 29/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMenuItemCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* itemName;
@property (nonatomic, weak) IBOutlet UIImageView* itemIcon;
@property (nonatomic, weak) IBOutlet UIImageView* notificationLabelBG;
@property (nonatomic, weak) IBOutlet UILabel* notificationCount;

- (void)setIndex:(NSInteger)index;

@end
