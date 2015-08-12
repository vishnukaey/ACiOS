//
//  LCMultipleSelectionTable.m
//  LegacyConnect
//
//  Created by User on 8/3/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCMultipleSelectionTable.h"

@implementation LCMultipleSelectionTable
@synthesize selectedRows, selectedButton;

- (void)AddIndexPath :(NSIndexPath *)indexPath
{
  if (!selectedRows) {
    selectedRows = [[NSMutableArray alloc]init];
  }
  [selectedRows addObject:indexPath];
  [selectedButton setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
}

- (BOOL)indexPathSelected :(NSIndexPath *)indexPath;
{
  for (int i=0 ; i<selectedRows.count ; i++)
  {
    NSIndexPath *path = [selectedRows objectAtIndex:i];
    if (path.section == indexPath.section)
    {
      [selectedRows removeObjectAtIndex:i];
      [selectedButton setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
      return YES;
    }
  }
  return NO;
}

- (void)setImageForButton:(UIButton *)button
{
  for (NSIndexPath *path in selectedRows)
  {
    if (path.section == button.tag)
    {
      [button setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
      return;
    }
  }
  [button setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
