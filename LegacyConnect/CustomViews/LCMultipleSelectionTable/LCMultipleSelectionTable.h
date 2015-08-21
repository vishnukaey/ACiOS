//
//  LCMultipleSelectionTable.h
//  LegacyConnect
//
//  Created by User on 8/3/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMultipleSelectionTable : UITableView

@property(nonatomic, retain)NSMutableArray *selectedIDs;
@property(nonatomic, retain)UIButton *selectedButton;

- (void)AddOrRemoveID :(id)ID_;
- (void)setStatusForButton:(UIButton *)button byCheckingIDs:(NSArray *)IDs;

@end
