//
//  LCTutorialView.m
//  LegacyConnect
//
//  Created by Jijo on 3/15/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCTutorialView.h"

@interface LCTutorialView ()
{
   
}

@end

@implementation LCTutorialView

- (void) awakeFromNib {
  [super awakeFromNib];
  _tapToDismissLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:13.0f];
}

- (UIColor *)colorTransparentBlack
{
  return [UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.9];
}

- (UIColor *)colorFontGrey
{
  return [UIColor grayColor];
}

- (UIColor *)colorFontRed
{
  return [UIColor colorWithRed:250.0f/255 green:70.0f/255 blue:22.0f/255 alpha:1];
}

- (UIFont *)font
{
  return [UIFont fontWithName:@"Gotham-Bold" size:13.0f];
}

- (float)lineSpacing
{
  return 10;
}


@end
