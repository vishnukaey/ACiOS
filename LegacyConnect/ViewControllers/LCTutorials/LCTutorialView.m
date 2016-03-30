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
  
  UIButton *button = [[UIButton alloc] init];
  [self addSubview:button];
  [button addTarget:self action:@selector(dismissTutorial) forControlEvents:UIControlEventTouchUpInside];
  button.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSLayoutConstraint *lead =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
  [self addConstraint:lead];
  
  NSLayoutConstraint *trail =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
  [self addConstraint:trail];
  
  NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
  [self addConstraint:bottom];
  
  NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
  [self addConstraint:top];
  
}

- (void)dismissTutorial
{
  [self removeFromSuperview];
}

- (UIColor *)colorTransparentBlack
{
  return [UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.9];
}

- (UIColor *)colorFontGrey
{
  return [UIColor colorWithRed:247.0f/255 green:247.0f/255 blue:247.0f/255 alpha:1.0];
}

- (UIColor *)colorFontRed
{
  return [LCUtilityManager getThemeRedColor];
}

- (UIFont *)lightFont
{
  return [UIFont fontWithName:@"Gotham-book" size:13.0f];
}

- (UIFont *)boldFont
{
  return [UIFont fontWithName:@"Gotham-bold" size:13.0f];
}

- (float)lineSpacing
{
  return 6;
}


@end
