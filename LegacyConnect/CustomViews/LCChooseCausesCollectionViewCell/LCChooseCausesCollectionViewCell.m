//
//  LCChooseCausesCollectionViewCell.m
//  LegacyConnect
//
//  Created by Vishnu on 7/17/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseCausesCollectionViewCell.h"

@interface LCChooseCausesCollectionViewCell ()
{
  IBOutlet UIView *outerBorder;
}
@end

@implementation LCChooseCausesCollectionViewCell

- (void) awakeFromNib {
  [super awakeFromNib];
  self.causesImageView.layer.cornerRadius = 6;
  self.causesImageView.clipsToBounds = YES;
  outerBorder.backgroundColor = [UIColor clearColor];
  outerBorder.layer.cornerRadius = 8;
  outerBorder.layer.borderWidth = 2;
  outerBorder.layer.borderColor = [UIColor colorWithRed:248.0f/255.0 green:195.0f/255.0 blue:62.0f/255.0 alpha:1.0]
  .CGColor;
}

-(void)setCause:(LCCause *)cause
{
  _cause = cause;
  
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] CGColor]);
  CGContextFillRect(context, rect);
  UIImage *placeHolder_image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  
  [_causesImageView sd_setImageWithURL:[NSURL URLWithString:cause.logoURLSmall] placeholderImage:placeHolder_image];//no placeholder needed. background color is placeholder itself
}

- (void)setCellSelected :(BOOL)selected
{
  if (selected)
  {
    outerBorder.hidden = false;
  }
  else
  {
    outerBorder.hidden = true;
  }
}

@end
