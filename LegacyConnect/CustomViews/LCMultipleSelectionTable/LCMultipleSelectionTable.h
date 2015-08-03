//
//  LCMultipleSelectionTable.h
//  LegacyConnect
//
//  Created by User on 8/3/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMultipleSelectionTable : UITableView

@property(nonatomic, retain)NSMutableArray *P_selectedRows;

- (void)checkButtonAction :(UIButton *)sender;
- (void)setImageForButton:(UIButton *)button;

@end
