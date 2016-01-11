//
//  LCMultipleSelectionTable.m
//  LegacyConnect
//
//  Created by User on 8/3/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCMultipleSelectionTable.h"

@implementation LCMultipleSelectionTable
@synthesize selectedIDs, selectedButton, checkedImage, uncheckedImage;

#pragma mark - Construction

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self && !selectedIDs)
  {
    selectedIDs = [[NSMutableArray alloc]init];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self && !selectedIDs)
  {
    selectedIDs = [[NSMutableArray alloc]init];
  }
  
  return self;
}

- (void)AddOrRemoveID :(id)ID_ 
{
  if ([selectedIDs containsObject:ID_])
  {
    [selectedIDs removeObject:ID_];
    [selectedButton setImage:uncheckedImage forState:UIControlStateNormal];
  }else
  {
    [selectedIDs addObject:ID_];
    [selectedButton setImage:checkedImage forState:UIControlStateNormal];
  }
}

- (void)setStatusForButton:(UIButton *)button byCheckingIDs:(NSArray *)IDs
{
  for (id ID_ in IDs)
  {
    if ([selectedIDs containsObject:ID_])
    {
      [button setImage:checkedImage forState:UIControlStateNormal];
      return;
    }
  }
  [button setImage:uncheckedImage forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
