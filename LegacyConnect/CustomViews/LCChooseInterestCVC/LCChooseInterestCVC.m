//
//  LCChooseInterestCVC.m
//  LegacyConnect
//
//  Created by Vishnu on 8/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseInterestCVC.h"


@implementation LCChooseInterestCVC

-(void)setInterest:(LCInterest *)interest
{
  _interest = interest;
  [_interestsImageView sd_setImageWithURL:[NSURL URLWithString:interest.logoURLLarge] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  _interestNameLabel.text = interest.descriptionText;
}

@end
