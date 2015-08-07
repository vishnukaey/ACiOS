//
//  LCChooseCausesCollectionViewCell.m
//  LegacyConnect
//
//  Created by Vishnu on 7/17/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseCausesCollectionViewCell.h"

@implementation LCChooseCausesCollectionViewCell


-(void)setCause:(LCCause *)cause
{
  _cause = cause;
  [_causesImageView sd_setImageWithURL:[NSURL URLWithString:cause.logoURLSmall] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
}

@end
