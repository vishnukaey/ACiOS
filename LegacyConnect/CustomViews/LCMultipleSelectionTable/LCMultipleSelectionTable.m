//
//  LCMultipleSelectionTable.m
//  LegacyConnect
//
//  Created by User on 8/3/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCMultipleSelectionTable.h"

@implementation LCMultipleSelectionTable
@synthesize P_selectedRows, P_selectedButton;

- (void)AddIndexPath :(NSIndexPath *)indexPath
{
  if (!P_selectedRows) {
    P_selectedRows = [[NSMutableArray alloc]init];
  }
  [P_selectedRows addObject:indexPath];
  [P_selectedButton setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
}

- (BOOL)indexPathSelected :(NSIndexPath *)indexPath;
{
  for (int i=0 ; i<P_selectedRows.count ; i++)
  {
    NSIndexPath *path = [P_selectedRows objectAtIndex:i];
    if (path.section == indexPath.section)
    {
      [P_selectedRows removeObjectAtIndex:i];
      [P_selectedButton setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
      return YES;
    }
  }
  return NO;
}

- (void)setImageForButton:(UIButton *)button
{
  for (NSIndexPath *path in P_selectedRows)
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
