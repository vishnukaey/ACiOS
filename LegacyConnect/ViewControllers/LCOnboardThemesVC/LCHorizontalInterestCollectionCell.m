//
//  LCHorizontalInterestCollectionCell.m
//  LegacyConnect
//
//  Created by Jijo on 12/18/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCHorizontalInterestCollectionCell.h"

@implementation LCHorizontalInterestCollectionCell

static NSString *kUnCheckedImageName = @"contact_plus";
static NSString *kCheckedImageName = @"contact_tick";

- (void)setInterestSelected :(BOOL)isSelected
{
  if (isSelected) {
    [self.checkMark setImage:[UIImage imageNamed:kCheckedImageName]];
  }
  else
  {
    [self.checkMark setImage:[UIImage imageNamed:kUnCheckedImageName]];
  }
}

- (void)setInterest:(LCInterest *)interest
{
  _interest = interest;
  self.interestLogo.layer.cornerRadius = 8.0f;
  self.interestLogo.clipsToBounds = YES;
  [self.interestLogo sd_setImageWithURL:[NSURL URLWithString:interest.logoURLSmall] placeholderImage:[UIImage imageNamed:@"InterestPlaceholder"]];
  self.interestName.text = interest.name;
}

@end
