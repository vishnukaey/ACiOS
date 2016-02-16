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
  self.causesImageView.layer.cornerRadius = 5.0f;
  self.causesImageView.clipsToBounds = YES;
  
  [self.containerView.layer setCornerRadius:5.0f];
  [self.containerView setClipsToBounds:YES];
  [self.containerView.layer setBorderColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor];
  [self.containerView.layer setBorderWidth:1];

}

-(void)setCause:(LCCause *)cause
{
  _cause = cause;
  
//  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//  UIGraphicsBeginImageContext(rect.size);
//  CGContextRef context = UIGraphicsGetCurrentContext();
//  CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] CGColor]);
//  CGContextFillRect(context, rect);
//  UIImage *placeHolder_image = UIGraphicsGetImageFromCurrentImageContext();
//  UIGraphicsEndImageContext();
  
  if(_causeLabel)
  {
    _causeLabel.text = cause.name;
  }
  [_causesImageView setBackgroundColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0]];
  [_causesImageView sd_setImageWithURL:[NSURL URLWithString:cause.logoURLSmall] placeholderImage:[UIImage imageNamed:@"cause_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    if (image) {
      [_causesImageView setBackgroundColor:[UIColor whiteColor]];
    }
  }];
}

- (void)setCellSelected:(BOOL)selected
{
  if (selected)
  {
    _selectionButton.selected = YES;
  }
  else
  {
    _selectionButton.selected = NO;
  }
}

@end
