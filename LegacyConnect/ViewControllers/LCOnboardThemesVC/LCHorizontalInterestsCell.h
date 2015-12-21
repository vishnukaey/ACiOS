//
//  LCHorizontalInterestsCell.h
//  LegacyConnect
//
//  Created by Jijo on 12/15/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCHorizontalInterestsCell : UITableViewCell

@property(nonatomic, retain)IBOutlet UIButton *showAllButton;
@property(nonatomic, retain)IBOutlet UILabel *themeLabel;
@property(nonatomic, retain)NSMutableArray *selectedItems;
@property(nonatomic, retain)NSArray *interestsArray;
@property(nonatomic, retain)LCTheme *theme;
@property(nonatomic, weak)UIButton *nextButton;

@end
