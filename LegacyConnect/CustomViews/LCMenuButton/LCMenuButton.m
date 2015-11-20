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
    badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * .52f, 3, 20, 20)];
    badgeLabel.backgroundColor = [UIColor whiteColor];
    badgeLabel.textColor = [UIColor colorWithRed:239.0/255 green:100.0/255 blue:77.0/255 alpha:1];
    badgeLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:11];
    [self addSubview:badgeLabel];
    badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width/2;
    badgeLabel.layer.borderColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:.5].CGColor;
    badgeLabel.layer.borderWidth = 1;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.clipsToBounds = YES;
    badgeLabel.adjustsFontSizeToFitWidth = YES;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 12, 30, 30)];
    self.iconImage.image = [UIImage imageNamed:@"MenuButton"];
    [self addSubview:self.iconImage];
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
