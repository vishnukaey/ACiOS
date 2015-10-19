//
//  LCChooseInterestCVC.m
//  LegacyConnect
//
//  Created by Vishnu on 8/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseInterestCVC.h"
@interface LCChooseInterestCVC ()
{
  IBOutlet UIView *imageSuperView;
  IBOutlet UIView *imageOverLay;
  IBOutlet UIView *outerBorder;
}
@end

@implementation LCChooseInterestCVC

- (void) awakeFromNib {
  [super awakeFromNib];
  imageSuperView.clipsToBounds = YES;
  imageSuperView.layer.cornerRadius = 6;
  outerBorder.backgroundColor = [UIColor clearColor];
  outerBorder.hidden = true;
  outerBorder.layer.cornerRadius = 8;
  outerBorder.layer.borderWidth = 2;
  outerBorder.layer.borderColor = [UIColor colorWithRed:248.0f/255.0 green:195.0f/255.0 blue:62.0f/255.0 alpha:1.0]
.CGColor;
}

-(void)setInterest:(LCInterest *)interest
{
  _interest = interest;

  _interestNameLabel.text = interest.name;
}

- (void)setCellSelected :(BOOL)selected
{
  if (selected)
  {
    outerBorder.hidden = false;
    imageOverLay.hidden = false;
  }
  else
  {
    outerBorder.hidden = true;
    imageOverLay.hidden = true;
  }
}

@end
