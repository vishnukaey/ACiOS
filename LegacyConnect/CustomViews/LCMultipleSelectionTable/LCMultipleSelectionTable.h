//
//  LCMultipleSelectionTable.h
//  LegacyConnect
//
//  Created by User on 8/3/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMultipleSelectionTable : UITableView

@property(nonatomic, retain)NSMutableArray *selectedRows;
@property(nonatomic, retain)UIButton *selectedButton;

- (void)AddIndexPath :(NSIndexPath *)indexPath;
- (BOOL)indexPathSelected :(NSIndexPath *)indexPath;
- (void)setImageForButton:(UIButton *)button;

@end
