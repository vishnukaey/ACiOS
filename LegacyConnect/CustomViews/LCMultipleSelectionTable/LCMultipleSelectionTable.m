//
//  LCMultipleSelectionTable.m
//  LegacyConnect
//
//  Created by User on 8/3/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCMultipleSelectionTable.h"

@implementation LCMultipleSelectionTable
@synthesize P_selectedRows;

- (void)checkButtonAction :(UIButton *)sender
{
  if (!P_selectedRows) {
    P_selectedRows = [[NSMutableArray alloc]init];
  }
  NSNumber *obj = [NSNumber numberWithInteger:sender.tag];
  
  if (![P_selectedRows containsObject:obj])
  {
    [P_selectedRows addObject:obj];
    [sender setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
  }
  else
  {
    [P_selectedRows removeObject:obj];
    [sender setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
  }
}

- (void)setImageForButton:(UIButton *)button
{
  NSNumber *obj = [NSNumber numberWithInteger:button.tag];
  if (![P_selectedRows containsObject:obj])
  {
    [button setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
  }
  else
  {
    [button setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
  }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
