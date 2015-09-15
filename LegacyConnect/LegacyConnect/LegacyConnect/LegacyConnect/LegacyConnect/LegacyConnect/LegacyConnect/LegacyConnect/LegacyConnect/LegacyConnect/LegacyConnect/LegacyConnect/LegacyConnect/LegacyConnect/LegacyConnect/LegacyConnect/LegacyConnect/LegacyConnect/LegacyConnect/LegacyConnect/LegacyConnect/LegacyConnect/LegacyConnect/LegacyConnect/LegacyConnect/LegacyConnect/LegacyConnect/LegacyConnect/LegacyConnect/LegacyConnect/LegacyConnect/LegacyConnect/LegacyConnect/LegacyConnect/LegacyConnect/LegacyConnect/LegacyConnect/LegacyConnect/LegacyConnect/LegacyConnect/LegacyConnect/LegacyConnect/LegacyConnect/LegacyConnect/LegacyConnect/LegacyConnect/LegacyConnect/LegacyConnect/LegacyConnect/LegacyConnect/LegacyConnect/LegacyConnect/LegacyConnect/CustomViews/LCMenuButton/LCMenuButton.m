//
//  LCMenuButton.m
//  LegacyConnect
//
//  Created by User on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCMenuButton.h"

@implementation LCMenuButton
@synthesize badgeLabel;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.width/2)];
    badgeLabel.backgroundColor = [UIColor blackColor];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = [UIFont systemFontOfSize:10];
    badgeLabel.text = @"";
    [self addSubview:badgeLabel];
    badgeLabel.layer.cornerRadius = frame.size.width/4;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.clipsToBounds = YES;
  }
  return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
