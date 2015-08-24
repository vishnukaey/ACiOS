//
//  LCMultipleSelectionTable.m
//  LegacyConnect
//
//  Created by User on 8/3/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCMultipleSelectionTable.h"

@implementation LCMultipleSelectionTable
@synthesize selectedIDs, selectedButton;

#pragma mark - Construction

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    if (!selectedIDs) {
      selectedIDs = [[NSMutableArray alloc]init];
    }
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    if (!selectedIDs) {
      selectedIDs = [[NSMutableArray alloc]init];
    }
  }
  
  return self;
}

- (void)AddOrRemoveID :(id)ID_ 
{
  if ([selectedIDs containsObject:ID_])
  {
    [selectedIDs removeObject:ID_];
    [selectedButton setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
  }else
  {
    [selectedIDs addObject:ID_];
    [selectedButton setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
  }
}

- (void)setStatusForButton:(UIButton *)button byCheckingIDs:(NSArray *)IDs
{
  for (id ID_ in IDs)
  {
    if ([selectedIDs containsObject:ID_])
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
