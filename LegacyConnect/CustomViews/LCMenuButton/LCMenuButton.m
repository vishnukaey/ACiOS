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
    [self setupMenuButtonUI];
  }
  return self;
}

-(void) setupMenuButtonUI
{
  /**
   * Notification count badge label from Menu button is removed temporarely. This can be shown in later
   * stage by uncommenting below line of codes.
   */
  
  //    badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * .52f, 3, 20, 20)];
  //    badgeLabel.backgroundColor = [UIColor whiteColor];
  //    badgeLabel.textColor = [LCUtilityManager getThemeRedColor];
  //    badgeLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:11];
  //    [self addSubview:badgeLabel];
  //    badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width/2;
  //    badgeLabel.layer.borderColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:.5].CGColor;
  //    badgeLabel.layer.borderWidth = 1;
  //    badgeLabel.textAlignment = NSTextAlignmentCenter;
  //    badgeLabel.clipsToBounds = YES;
  //    badgeLabel.adjustsFontSizeToFitWidth = YES;
  
  self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2 - 12, 25, 25)];
  self.iconImage.image = [UIImage imageNamed:@"MenuButton"];
  [self addSubview:self.iconImage];
}

@end
